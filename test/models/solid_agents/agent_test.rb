# frozen_string_literal: true

require "test_helper"

module SolidAgents
  class AgentTest < ActiveSupport::TestCase
    test "validates role" do
      agent = Agent.new(key: "zara", name: "Zara", runtime: "pi", role: "nope")
      assert_not agent.valid?
      assert_includes agent.errors[:role], "is not included in the list"
    end

    test "capability helper" do
      agent = SolidAgents::Agent.find(fixture_id(:alex))
      agent.update!(capabilities_json: {"allow_pr" => true})

      assert agent.capability?("allow_pr")
      assert_not agent.capability?("allow_push")
    end
  end
end
