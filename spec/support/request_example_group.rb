# http://codingfrontier.com/integration-testing-setup-with-rspec-2-and-ca
require 'action_dispatch'
require 'capybara/rails'
require 'capybara/dsl'

module RSpec::Rails
  module RequestExampleGroup
    extend ActiveSupport::Concern
    extend RSpec::Rails::ModuleInclusion

    include ActionDispatch::Integration::Runner
    include RSpec::Rails::TestUnitAssertionAdapter
    include ActionDispatch::Assertions
    include Capybara
    include RSpec::Matchers
    include RSpec::Rails::Matchers::RedirectTo
    include RSpec::Rails::Matchers::RenderTemplate
    include ActionController::TemplateAssertions

    module InstanceMethods
      def app
        ::Rails.application
      end

      def last_response
        response
      end
    end
    
    included do
      metadata[:type] = :request

      before do
        @router = ::Rails.application.routes
      end

      Webrat.configure do |config|
        config.mode = :rack
      end
    end

    RSpec.configure &include_self_when_dir_matches('spec','requests')
  end
end
