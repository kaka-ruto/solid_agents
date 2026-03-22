# frozen_string_literal: true

module SolidAgents
  class Artifact < Record
    self.table_name = "solid_agents_artifacts"

    belongs_to :run, class_name: "SolidAgents::Run"

    validates :kind, :storage_type, presence: true
  end
end
