# frozen_string_literal: true

require_relative "agents/base"
require_relative "agents/alex"
require_relative "agents/betty"
require_relative "agents/chad"
require_relative "agents/david"
require_relative "agents/eddy"

module SolidAgents
  module Agents
    AGENT_CLASSES = {
      "alex" => SolidAgents::Agents::Alex,
      "betty" => SolidAgents::Agents::Betty,
      "chad" => SolidAgents::Agents::Chad,
      "david" => SolidAgents::Agents::David,
      "eddy" => SolidAgents::Agents::Eddy
    }.freeze

    module_function

    def for_owner(owner)
      AGENT_CLASSES.fetch(owner.to_s, SolidAgents::Agents::Alex)
    end
  end
end
