# frozen_string_literal: true

module SolidAgents
  class Run < Record
    self.table_name = "solid_agents_runs"

    STATUSES = {
      queued: "queued",
      running: "running",
      blocked: "blocked",
      pr_opened: "pr_opened",
      succeeded: "succeeded",
      failed: "failed",
      canceled: "canceled"
    }.freeze

    belongs_to :agent, class_name: "SolidAgents::Agent"
    has_many :events, class_name: "SolidAgents::RunEvent", foreign_key: :run_id, dependent: :delete_all
    has_many :artifacts, class_name: "SolidAgents::Artifact", foreign_key: :run_id, dependent: :delete_all
    has_many :handoffs, class_name: "SolidAgents::Handoff", foreign_key: :run_id, dependent: :delete_all
    has_one :work_item, class_name: "SolidAgents::WorkItem", foreign_key: :run_id, dependent: :delete

    enum :status, STATUSES

    validates :runtime, :environment, :status, :source_type, :stage, presence: true
    validates :external_key, uniqueness: true, allow_nil: true

    before_validation :set_defaults, on: :create

    def append_event!(event_type, message:, payload: nil, actor: nil)
      next_sequence = (events.maximum(:sequence) || 0) + 1
      events.create!(
        event_type: event_type,
        message: message,
        payload: payload || {},
        actor: actor || stage_owner,
        event_time: Time.current,
        sequence: next_sequence
      )
    end

    def transition_to!(next_stage, actor:, message:, payload: {})
      update!(stage: next_stage, stage_owner: SolidAgents::Workflow.stage_agent(next_stage))
      work_item&.update!(column_key: next_stage)
      append_event!("stage_transitioned", message: message, payload: payload.merge("next_stage" => next_stage), actor: actor)
    end

    def start_stage!(actor:)
      update!(status: :running, started_at: (started_at || Time.current))
      append_event!("stage_started", message: "Stage #{stage} started", payload: {"stage" => stage}, actor: actor)
    end

    def complete!(result_payload:, actor:)
      update!(status: :succeeded, stage: "done", stage_owner: SolidAgents::Workflow.stage_agent("done"), finished_at: Time.current, result_payload: result_payload)
      work_item&.update!(column_key: "done")
      append_event!("run_completed", message: "Run completed successfully", payload: result_payload, actor: actor)
    end

    def fail!(error_payload:, actor:)
      update!(status: :failed, finished_at: Time.current, error_payload: error_payload)
      work_item&.update!(column_key: "failed")
      append_event!("run_failed", message: "Run failed", payload: error_payload, actor: actor)
    end

    private

    def set_defaults
      self.status ||= :queued
      self.stage ||= "received"
      self.stage_owner ||= SolidAgents::Workflow.stage_agent(stage)
      self.runtime ||= agent&.runtime || SolidAgents.default_runtime.to_s
      self.environment ||= Rails.env
      self.test_command ||= SolidAgents.default_test_command
    end
  end
end
