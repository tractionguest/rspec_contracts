# frozen_string_literal: true

module RspecContracts
  class Railtie < Rails::Railtie
    initializer "rspec_contracts" do
      RspecContracts.install
    end
  end
end
