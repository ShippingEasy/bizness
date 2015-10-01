$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bizness'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }
I18n.config.available_locales = :en
I18n.load_path = Dir[File.dirname(__FILE__) + "/support/**/*.yml"]
I18n.backend.load_translations
