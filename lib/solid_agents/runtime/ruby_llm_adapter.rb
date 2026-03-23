# frozen_string_literal: true

require "ruby_llm"

module SolidAgents
  module Runtime
    class RubyLlmAdapter < Adapter
      def execute(run:, prompt:)
        agent_class = SolidAgents::Agents.for_owner(run.stage_owner)
        agent = agent_class.new(run: run, context: run.prompt_payload || {})
        response = agent.call(prompt)
        output = response.respond_to?(:content) ? response.content.to_s : response.to_s

        Result.new(ok: true, output: output, error: nil, metadata: {agent_class: agent_class.name, stage: run.stage, owner: run.stage_owner})
      rescue StandardError => e
        Result.new(ok: false, output: nil, error: e.message, metadata: {agent_class: agent_class&.name, stage: run.stage, owner: run.stage_owner, exception: e.class.name})
      end
    end
  end
end
