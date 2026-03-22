# frozen_string_literal: true

module SolidAgents
  module Runs
    class Dispatch
      def self.call(source:, agent_key:)
        environment = Rails.env
        agent = SolidAgents::Agent.enabled.for_environment(environment).find_by!(key: agent_key)

        run = SolidAgents::Run.create!(
          agent: agent,
          source_type: source.class.name,
          source_id: source.respond_to?(:id) ? source.id : nil,
          runtime: agent.runtime,
          environment: environment,
          external_key: "#{source.class.name}-#{source.respond_to?(:id) ? source.id : source.object_id}-#{Time.current.to_i}",
          repo_path: agent.working_directory,
          base_branch: "main",
          max_iterations: agent.max_iterations
        )

        context = ContextBuilder.call(source: source)
        run.update!(prompt_payload: context)
        run.append_event!("dispatched", message: "Run dispatched from source", payload: {agent_key: agent.key})

        SolidAgents::ExecuteRunJob.perform_later(run.id)
        run
      end
    end
  end
end
