# frozen_string_literal: true

module SolidAgents
  class RunsController < ApplicationController
    helper SolidAgents::RunsHelper
    before_action :set_run, only: %i[show retry]

    def index
      @runs = SolidAgents::Run.includes(:agent).order(created_at: :desc).limit(100)
    end

    def show
      @events = @run.events.order(sequence: :asc)
      @artifacts = @run.artifacts.order(created_at: :desc)
    end

    def retry
      duplicated = @run.dup
      duplicated.status = :queued
      duplicated.started_at = nil
      duplicated.finished_at = nil
      duplicated.error_payload = nil
      duplicated.result_payload = nil
      duplicated.external_key = "retry-#{@run.id}-#{Time.current.to_i}"
      duplicated.save!
      duplicated.append_event!("retried", message: "Run created from retry", payload: {original_run_id: @run.id})
      SolidAgents::ExecuteRunJob.perform_later(duplicated.id)

      redirect_to run_path(duplicated), notice: "Run retried."
    end

    private

    def set_run
      @run = SolidAgents::Run.find(params[:id])
    end
  end
end
