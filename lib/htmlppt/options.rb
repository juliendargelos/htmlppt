class Htmlppt::Options
  DEFAULT = {
    title_selector: 'title',
    slide_selector: 'section',
    slide_title_selector: 'h2',
    slide_text_selector: 'p',
    slide_image_selector: 'img',
    slide_description_selector: 'figcaption'
  }

  def initialize options = {}
    self.update options
  end

  def to_h
    self.keys.map{ |key| [key, self.send(key)] }.to_h
  end
  alias_method :to_hash, :to_h

  def update options = {}
    options = options.to_h if options.is_a? self.class
    options.each { |option, value| self.try option.to_s+'=', value } if options.is_a? Hash
    self
  end

  def default!
    self.update self.class.default
  end

  def self.exists? option
    option = option.to_sym if option.is_a? String
    options.is_a?(Symbol) ? DEFAULTS.key?(option) : false
  end

  def self.default
    @@default
  end

  def self.default= v
    if v.is_a?(self) || v.is_a?(Hash)
      @@default = self.new v
    else
      self.default!
    end
  end

  def self.default!
    self.default = self.new DEFAULT
  end

  def self.keys
    DEFAULT.keys
  end
  delegate :keys, to: :class

  keys.each do |option|
    option = option.to_s
    define_method option, &proc { instance_variable_get('@'+option) || self.class.default.send(option) }
    define_method option+'=', &proc { |v| instance_variable_set('@'+option, v) }
  end

  default!
end
