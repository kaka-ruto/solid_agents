# frozen_string_literal: true

require "json"

module SolidAgents
  module Runs
    class PromptBuilder
      def self.call(run:, context:)
        <<~PROMPT
          You are #{run.agent.name} (#{run.agent.role}).
          Goal: fix the reported Rails issue end-to-end.

          Constraints:
          - Work in repository: #{run.repo_path}
          - Base branch: #{run.base_branch}
          - Test command: #{run.test_command}
          - Max iterations: #{run.max_iterations || SolidAgents.max_iterations}
          - Open PR allowed: #{run.agent.capability?("allow_pr")}

          Context JSON:
          #{JSON.pretty_generate(context)}

          Definition of done:
          1) Root cause identified.
          2) Code fix applied.
          3) Tests added or updated.
          4) Tests executed and passing.
          5) Return final JSON with keys: status, branch_name, test_summary, pr_url, notes.
        PROMPT
      end
    end
  end
end
