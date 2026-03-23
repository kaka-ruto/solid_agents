# frozen_string_literal: true

require "test_helper"

module SolidAgents
  class RunsFlowTest < ActionDispatch::IntegrationTest
    test "index and show work" do
      run = SolidAgents::Run.find(fixture_id(:received_run))

      get "/solid_agents"
      assert_response :success
      assert_includes @response.body, "Runs"

      get "/solid_agents/#{run.id}"
      assert_response :success
      assert_includes @response.body, "Run ##{run.id}"
    end

    test "retry creates new run" do
      run = SolidAgents::Run.find(fixture_id(:received_run))

      assert_difference("SolidAgents::Run.count", 1) do
        post "/solid_agents/#{run.id}/retry"
      end

      assert_redirected_to %r{/solid_agents/\d+}
    end
  end
end
