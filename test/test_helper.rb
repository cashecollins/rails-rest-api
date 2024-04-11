ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    
    # Add more helper methods to be used by all tests here...
    def jwt
      user = users(:one)
      jwt = JWT.encode({ sub: user.id }, Rails.application.credentials.devise_jwt_secret_key!)
      jwt
    end
  end
end
