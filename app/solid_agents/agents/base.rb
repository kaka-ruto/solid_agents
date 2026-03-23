# frozen_string_literal: true

module SolidAgents
  module Agents
    class Base < RubyLLM::Agent
      model SolidAgents.default_model, provider: SolidAgents.default_provider
      tools SolidAgents::Tools::WorkflowGuideTool.new

      attr_reader :run, :context, :owner

      def initialize(run:, context:, owner:)
        @run = run
        @context = context
        @owner = owner.to_s
        super()
      end

      def call(prompt)
        ask(prompt)
      end

      def instructions
        template_path = File.expand_path("../prompts/#{owner}/instructions.txt.erb", __dir__)
        ERB.new(File.read(template_path)).result(binding)
      end
    end
  end
end
