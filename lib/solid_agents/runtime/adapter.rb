# frozen_string_literal: true

require "open3"

module SolidAgents
  module Runtime
    class Adapter
      Result = Struct.new(:ok, :output, :error, :metadata, keyword_init: true)

      def execute(_run:, _prompt:)
        raise NotImplementedError
      end

      private

      def run_command(*argv)
        stdout, stderr, status = Open3.capture3(*argv)
        Result.new(ok: status.success?, output: stdout, error: stderr, metadata: {exit_status: status.exitstatus, command: argv})
      end
    end
  end
end
