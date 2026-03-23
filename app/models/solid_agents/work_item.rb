# frozen_string_literal: true

module SolidAgents
  class WorkItem < Record
    self.table_name = "solid_agents_work_items"

    belongs_to :run, class_name: "SolidAgents::Run"

    validates :column_key, :title, presence: true
  end
end
