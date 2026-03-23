# frozen_string_literal: true

require_relative "solid_agents/version"
require_relative "solid_agents/workflow"
require_relative "solid_agents/runtime/adapter"
require_relative "solid_agents/runtime/ruby_llm_adapter"
require_relative "solid_agents/engine"

module SolidAgents
  mattr_accessor :connects_to
  mattr_accessor :base_controller_class, default: "::ActionController::Base"
  mattr_accessor :default_runtime, default: :ruby_llm
  mattr_accessor :default_model, default: "gpt-5-nano"
  mattr_accessor :default_test_command, default: "bin/rails test"
  mattr_accessor :max_iterations, default: 8

  class << self
    def runtime_adapter(runtime)
      case runtime.to_sym
      when :ruby_llm then SolidAgents::Runtime::RubyLlmAdapter.new
      else
        raise ArgumentError, "Unsupported runtime: #{runtime.inspect}"
      end
    end

    def dispatch_error(source:, agent_key: "alex")
      SolidAgents::Runs::Dispatch.call(source: source, agent_key: agent_key)
    end
  end
end
