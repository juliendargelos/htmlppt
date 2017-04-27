Rails::Application::Configuration.class_eval do
  def htmlppt
    Htmlppt::Options.default
  end

  def htmlppt= v
    Htmlppt::Options.default = v
  end
end
