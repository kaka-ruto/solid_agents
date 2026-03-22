# frozen_string_literal: true

require "test_helper"

module SolidAgents
  class AgentsControllerTest < ActionDispatch::IntegrationTest
    test "index show edit update" do
      agent = SolidAgents::Agent.create!(key: "fixer", name: "Fixer", runtime: "tinyclaw", role: "fixer")

      get "/solid_agents/agents"
      assert_response :success
      assert_includes @response.body, "Agents"

      get "/solid_agents/agents/#{agent.id}"
      assert_response :success
      assert_includes @response.body, "Agent: fixer"

      get "/solid_agents/agents/#{agent.id}/edit"
      assert_response :success

      patch "/solid_agents/agents/#{agent.id}", params: {agent: {name: "Fixer 2"}}
      assert_redirected_to "/solid_agents/agents/#{agent.id}"
      assert_equal "Fixer 2", agent.reload.name
    end
  end
end
