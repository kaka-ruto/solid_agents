# frozen_string_literal: true

module SolidAgents
  module Runtime
    class TinyclawAdapter < Adapter
      def execute(run:, prompt:)
        command = [SolidAgents.tinyclaw_command.to_s, "send", "@#{run.agent.key} #{prompt}"]
        run_command(*command)
      end
    end
  end
end
