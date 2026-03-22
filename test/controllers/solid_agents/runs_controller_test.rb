# frozen_string_literal: true

require "test_helper"

module SolidAgents
  class RunsControllerTest < ActionDispatch::IntegrationTest
    test "index and show work" do
      agent = SolidAgents::Agent.create!(key: "fixer", name: "Fixer", runtime: "tinyclaw", role: "fixer")
      run = SolidAgents::Run.create!(agent: agent, source_type: "Error", runtime: "tinyclaw", environment: "test")
      run.append_event!("created", message: "created")

      get "/solid_agents"
      assert_response :success
      assert_includes @response.body, "Runs"

      get "/solid_agents/#{run.id}"
      assert_response :success
      assert_includes @response.body, "Run ##{run.id}"
    end

    test "retry creates new run" do
      agent = SolidAgents::Agent.create!(key: "fixer", name: "Fixer", runtime: "tinyclaw", role: "fixer")
      run = SolidAgents::Run.create!(agent: agent, source_type: "Error", runtime: "tinyclaw", environment: "test")

      assert_difference("SolidAgents::Run.count", 1) do
        post "/solid_agents/#{run.id}/retry"
      end

      assert_redirected_to %r{/solid_agents/\d+}
    end
  end
end
