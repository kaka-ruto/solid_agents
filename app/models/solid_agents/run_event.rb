# frozen_string_literal: true

module SolidAgents
  class RunEvent < Record
    self.table_name = "solid_agents_run_events"

    belongs_to :run, class_name: "SolidAgents::Run"

    validates :event_type, :message, :sequence, :event_time, presence: true
    validates :sequence, uniqueness: {scope: :run_id}
  end
end
