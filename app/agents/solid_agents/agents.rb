# frozen_string_literal: true

module SolidAgents
  module Agents
    AGENT_CLASSES = {
      "alex" => SolidAgents::Agents::AlexAgent,
      "betty" => SolidAgents::Agents::BettyAgent,
      "chad" => SolidAgents::Agents::ChadAgent,
      "david" => SolidAgents::Agents::DavidAgent,
      "eddy" => SolidAgents::Agents::EddyAgent
    }.freeze

    module_function

    def for_owner(owner)
      AGENT_CLASSES.fetch(owner.to_s, SolidAgents::Agents::AlexAgent)
    end
  end
end
