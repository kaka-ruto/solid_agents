# frozen_string_literal: true

module SolidAgents
  class ApplicationController < SolidAgents.base_controller_class.constantize
    layout "solid_agents/application"
    protect_from_forgery with: :exception
  end
end
