ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
I18n.default_locale = :en

RSpec.configure do |config|
  config.render_views # for jbuilder & simple view/html testing (fail on error)
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end
