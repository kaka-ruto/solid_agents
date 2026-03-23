# frozen_string_literal: true

module SolidAgents
  class Engine < ::Rails::Engine
    config.root = File.expand_path("../..", __dir__)
    isolate_namespace SolidAgents
    paths.add "app/solid_agents", eager_load: true

    config.solid_agents = ActiveSupport::OrderedOptions.new

    initializer "solid_agents.configure" do
      config.solid_agents.each do |name, value|
        SolidAgents.public_send(:"#{name}=", value)
      end
    end

    initializer "solid_agents.ruby_llm" do
      SolidAgents.openrouter_api_key ||= ENV["OPENROUTER_API_KEY"]
      SolidAgents.openrouter_api_base ||= ENV["OPENROUTER_API_BASE"]

      RubyLLM.configure do |config|
        config.openrouter_api_key = SolidAgents.openrouter_api_key if SolidAgents.openrouter_api_key.present?
        config.openrouter_api_base = SolidAgents.openrouter_api_base if SolidAgents.openrouter_api_base.present?
      end
    end
  end
end
