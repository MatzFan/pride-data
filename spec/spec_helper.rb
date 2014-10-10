ENV['RACK_ENV'] = 'test'

require_relative File.join('..', 'app')


RSpec.configure do |config|
  include Rack::Test::Methods # makes 'get' etc available

  def app
    Sinatra::Application
  end
end
