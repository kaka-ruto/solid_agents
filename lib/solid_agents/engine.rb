# frozen_string_literal: true

module SolidAgents
  class Engine < ::Rails::Engine
    config.root = File.expand_path("../..", __dir__)
    isolate_namespace SolidAgents

    config.solid_agents = ActiveSupport::OrderedOptions.new

    initializer "solid_agents.configure" do
      config.solid_agents.each do |name, value|
        SolidAgents.public_send(:"#{name}=", value)
      end
    end
  end
end
