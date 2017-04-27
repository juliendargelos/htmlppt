# Htmlppt
Parses HTML contents to generate PowerPoint files.
This gem uses the [Nogokiri gem](https://github.com/sparklemotion/nokogiri) to parse HTML, and the ['powerpoint' gem](https://github.com/pythonicrubyist/powerpoint) to generate PowerPoint files.

## Usage
### Basic
```ruby
converter = Htmlppt::Converter.new '<!doctype><html>...</html>'
converter.convert!
converter.save to: 'presentation.ppt'
```

### Loading HTML content
#### From string
```ruby
converter = Htmlppt::Converter.new content: '<!doctype><html>...</html>'
```

Or simply:
```ruby
converter = Htmlppt::Converter.new '<!doctype><html>...</html>'
```

#### From a file
```ruby
converter = Htmlppt::Converter.new file: 'index.html'
```

#### From an url
```ruby
converter = Htmlppt::Converter.new url: 'https://www.github.com'
```

#### After initialization
```ruby
converter = Htmlppt::Converter.new
converter.content = '<!doctype><html>...</html>'
converter.file = 'index.html'
converter.url = 'https://www.github.com'
```

### Defining parsing behavior
#### On initialization
```ruby
converter = Htmlppt::Converter.new '<!doctype><html>...</html>', {
  title_selector: 'h1',                            # Selects the first node matching in the page
  slide_selector: '.slide',                        # Selects all nodes matching in the page
  slide_title_selector: '.slide-title',            # Selects the first node matching in each slide
  slide_text_selector: '.slide-text',              # Selects all nodes matching in each slide
  slide_image_selector: '.slide-image',            # Selects the first node matching in each slide
  slide_description_selector: '.slide-description' # Selects all nodes matching in each slide
}
```

If want to load html from a file at the same time (same way from an url):
```ruby
converter = Htmlppt::Converter.new(
  file: 'index.html',
  title_selector: 'h1',
  slide_selector: '.slide',
  slide_title_selector: '.slide-title',
  slide_text_selector: '.slide-text',
  slide_image_selector: '.slide-image',
  slide_description_selector: '.slide-description'
)
```


#### After initialization
```ruby
converter = Htmlppt::Converter.new

converter.options.slide_selector = '.slide'

converter.options = {
  slide_selector: '.slide',
  slide_title_selector: '.slide-title'
}
```

#### To default
```ruby
converter.options.default!
# {
#   title_selector: 'title',
#   slide_selector: 'section',
#   slide_title_selector: 'h2',
#   slide_text_selector: 'p',
#   slide_image_selector: 'img',
#   slide_description_selector: 'figcaption'
# }
```

### Defining default parsing behavior
#### In Rails configuration
```ruby
# config/application.rb (could be development.rb, production.rb, ...)
module YourApp
  class Application < Rails::Application
    config.htmlppt.title_selector = '.slide-title'

    config.htmlppt = {
      slide_selector: '.slide',
      slide_title_selector: '.slide-title'
    }

    config.htmlppt.default! # Reset the default parsing behavior
  end
end
```

#### Anywhere
```ruby
Htmlppt::Options.default.title_selector = '.slide-title'

Htmlppt::Options.default = {
  slide_selector: '.slide',
  slide_title_selector: '.slide-title'
}

Html::Options.default! # Reset the default parsing behavior
```

### Converting & Saving
#### Converting
```ruby
converter.convert! # Convert and a return a Powerpoint::Presentation object from the powerpoint gem
```

#### Saving
```ruby
converter.save to: 'presentation.ppt'
converter.save to: :presentation # The ppt extension will be automatically added
converter.save to: :presentation, extension: false # The ppt extension will not be added
```

#### Convert then Save
```ruby
converter.convert! to: 'presentation.ppt'
converter.convert! to: :presentation # The ppt extension will be automatically added
converter.convert! to: :presentation, extension: false # The ppt extension will not be added
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'htmlppt', git: 'https://www.github.com/juliendargelos/htmlppt'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install htmlppt
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
