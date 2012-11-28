require 'mocha/version'
require 'mocha/integration'
require 'mocha/deprecation'
require 'mocha/setup'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

gem_name = File.basename(__FILE__).gsub(/\.rb$/, "")

Motion::Project::App.setup do |app|
  app.development do
    gem_files = Dir.glob(File.join(File.dirname(__FILE__), gem_name, "**/*.rb"))
    app.files = gem_files + app.files
  end
end
