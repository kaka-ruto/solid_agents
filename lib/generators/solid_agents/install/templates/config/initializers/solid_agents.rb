# frozen_string_literal: true

Rails.application.configure do
  # Optional: override in specific environments.
  # config.solid_agents.connects_to = { database: { writing: :solid_agents } }

  # Configure LLM access with environment variables:
  # OPENROUTER_API_KEY="..."
  # OPENROUTER_API_BASE="https://openrouter.ai/api/v1" # optional

  config.solid_agents.default_model = ENV.fetch("SOLID_AGENTS_DEFAULT_MODEL", "minimax/minimax-m2.7")
  config.solid_agents.default_provider = :openrouter
  config.solid_agents.default_test_command = ENV.fetch("SOLID_AGENTS_TEST_COMMAND", "bin/rails test")
  config.solid_agents.max_iterations = ENV.fetch("SOLID_AGENTS_MAX_ITERATIONS", 8).to_i
end
