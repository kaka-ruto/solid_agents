# frozen_string_literal: true

SolidAgents::Engine.routes.draw do
  resources :agents, only: %i[index show edit update]

  resources :runs, only: %i[index show], path: "" do
    member { post :retry }
  end
end
