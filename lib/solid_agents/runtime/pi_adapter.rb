# frozen_string_literal: true

module SolidAgents
  module Runtime
    class PiAdapter < Adapter
      def execute(run:, prompt:)
        command = [SolidAgents.pi_command.to_s, "agent", "run", "--json", "--message", prompt]
        run_command(*command).tap do |result|
          result.metadata[:stage] = run.stage
          result.metadata[:owner] = run.stage_owner
        end
      end
    end
  end
end
