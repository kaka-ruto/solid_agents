# frozen_string_literal: true

module SolidAgents
  class Handoff < Record
    self.table_name = "solid_agents_handoffs"

    belongs_to :run, class_name: "SolidAgents::Run"

    validates :from_agent, :to_agent, :stage, presence: true
  end
end
