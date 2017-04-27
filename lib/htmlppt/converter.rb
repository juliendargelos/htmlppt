class Htmlppt::Converter
  ORIGINS = [:content, :file, :url]

  @content = ''
  @document = nil
  @options = Htmlppt::Options.new

  def initialize origin = nil, options = nil
    origin = { content: origin } unless origin.is_a? Hash
    origin.symbolize_keys!

    self.options = options.nil? ? origin.except(ORIGINS) : options

    ORIGINS.each do |o|
      if origin.key? o
        self.send :"#{o}=", origin[o]
        break
      end
    end
  end

  def content
    @content
  end

  def content= v
    @content = v.to_s
    @document = nil
    @ppt = nil
  end

  def file= v
    self.content = File.read v
  end

  def url= v
    self.content = open(v).read
  end

  def parsed?
    !@document.nil?
  end

  def parse
    @document = Nokogiri::HTML self.content
  end

  def document
    self.parse unless self.parsed?
    @document
  end

  def ppt
    @ppt = Powerpoint::Presentation.new if @ppt.nil?
    @ppt
  end

  def clear!
    @ppt = nil
    true
  end

  def convert! save_options = {}
    save_options = {} unless save_options.is_a? Hash

    self.clear!
    self.ppt.add_intro self.title
    self.slides.each do |slide|
      self.slide! slide[:title].try(:text), {
        text: slide[:text].map(&:text),
        image: slide[:image].try(:src),
        description: slide[:text].map(&:text)
      }
    end
    self.save save_options if save_options.key? :to

    self.ppt
  end

  def save options = {}
    options = {} unless options.is_a? Hash
    path = options[:to].is_a?(Symbol) ? options[:to].to_s : options[:to]

    if path.is_a? String
      path = path.gsub(/\.ppt\z/i, '')+'.ppt' unless options[:extension] == false
      self.ppt.save path
    else
      false
    end
  end

  def options
    @options
  end

  def options= v
    if v.is_a? Htmlppt::Options
      @options = v
    elsif v.is_a? Hash
      @options.update v
    end
  end

  protected

  def title
    self.document.css(self.options.title_selector).first.try(:text)
  end

  def slides
    self.document.css(self.options.slide_selector).map do |slide|
      [:title, :text, :image, :description].map{ |part| [part, slide.css(self.options.send("slide_#{part}_selector"))] }.to_h
    end
  end

  def slide! title, options = {}
    options = {} unless options.is_a? Hash

    text = self.value options[:text], Array, of: String
    description = self.value options[:description], Array, of: String
    image = self.value options[:image], String
    coordinates = self.value options[:coordinates], Hash

    if image && text
      self.ppt.add_text_picture_slide title, image, text
    elsif image && description
      self.ppt.add_picture_description_slide title, image, description
    elsif image
      self.ppt.add_pictorial_slide title, image, coordinates
    elsif text
      self.ppt.add_textual_slide title, text
    end
  end

  def value value, type, options = {}
    options = {} unless options.is_a? Hash

    if type.is_a? Class
      if type == Array
        if options[:of].is_a? Class
          value = [value] if value.is_a? options[:of]
        end

        if value.is_a?(Array)
          value = nil if options[:empty] == false && value.empty?
        else
          value = nil
        end
      else
        value = nil unless value.is_a?(type)
      end
    else
      value = nil
    end

    value
  end
end
