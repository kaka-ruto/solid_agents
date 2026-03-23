# frozen_string_literal: true

module SolidAgents
  module Agents
    class BaseAgent < RubyLLM::Agent
      model { SolidAgents.default_model }
      instructions

      attr_reader :run, :context

      def initialize(run:, context:)
        @run = run
        @context = context
        super()
      end

      def call(prompt)
        ask(prompt)
      end
    end
  end
end
