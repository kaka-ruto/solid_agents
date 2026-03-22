# frozen_string_literal: true

module SolidAgents
  module Runtime
    class OpenclawAdapter < Adapter
      def execute(run:, prompt:)
        command = [SolidAgents.openclaw_command.to_s, "agent", "--message", prompt, "--thinking", "high"]
        run_command(*command)
      end
    end
  end
end
