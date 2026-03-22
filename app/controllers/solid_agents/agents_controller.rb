# frozen_string_literal: true

module SolidAgents
  class AgentsController < ApplicationController
    before_action :set_agent, only: %i[show edit update]

    def index
      @agents = SolidAgents::Agent.order(:key)
    end

    def show; end

    def edit; end

    def update
      if @agent.update(agent_params)
        redirect_to agent_path(@agent), notice: "Agent updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_agent
      @agent = SolidAgents::Agent.find(params[:id])
    end

    def agent_params
      params.require(:agent).permit(:name, :role, :runtime, :enabled, :model, :working_directory, :timeout_seconds, :max_iterations, :environment, :system_prompt)
    end
  end
end
