# frozen_string_literal: true

Rails.application.routes.draw do
  mount SolidAgents::Engine, at: "/solid_agents"
end
