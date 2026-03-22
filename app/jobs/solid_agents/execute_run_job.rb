# frozen_string_literal: true

module SolidAgents
  class ExecuteRunJob < ActiveJob::Base
    queue_as :default

    def perform(run_id)
      run = SolidAgents::Run.find(run_id)
      SolidAgents::Runs::Executor.call(run)
    end
  end
end
