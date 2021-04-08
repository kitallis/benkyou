require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Benkyou
  class Application < Rails::Application
    config.load_defaults 6.1

    config.generators do |g|
      g.test_framework :minitest, spec: false, fixture: false
    end
  end
end
