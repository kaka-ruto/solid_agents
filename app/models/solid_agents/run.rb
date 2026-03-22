# frozen_string_literal: true

module SolidAgents
  class Run < Record
    self.table_name = "solid_agents_runs"

    STATUSES = {
      queued: "queued",
      running: "running",
      pr_opened: "pr_opened",
      succeeded: "succeeded",
      failed: "failed",
      canceled: "canceled"
    }.freeze

    belongs_to :agent, class_name: "SolidAgents::Agent"
    has_many :events, class_name: "SolidAgents::RunEvent", foreign_key: :run_id, dependent: :delete_all
    has_many :artifacts, class_name: "SolidAgents::Artifact", foreign_key: :run_id, dependent: :delete_all

    enum :status, STATUSES

    validates :runtime, :environment, :status, :source_type, presence: true
    validates :external_key, uniqueness: true, allow_nil: true

    before_validation :set_defaults, on: :create

    def append_event!(event_type, message:, payload: nil)
      next_sequence = (events.maximum(:sequence) || 0) + 1
      events.create!(event_type: event_type, message: message, payload: payload || {}, event_time: Time.current, sequence: next_sequence)
    end

    private

    def set_defaults
      self.status ||= :queued
      self.runtime ||= agent&.runtime || SolidAgents.default_runtime.to_s
      self.environment ||= Rails.env
      self.test_command ||= SolidAgents.default_test_command
    end
  end
end
