# frozen_string_literal: true

Rails.application.configure do
  # Optional: override in specific environments.
  # config.solid_agents.connects_to = { database: { writing: :solid_agents } }

  config.solid_agents.default_model = ENV.fetch("SOLID_AGENTS_DEFAULT_MODEL", "gpt-5-nano")
  config.solid_agents.default_test_command = ENV.fetch("SOLID_AGENTS_TEST_COMMAND", "bin/rails test")
  config.solid_agents.max_iterations = ENV.fetch("SOLID_AGENTS_MAX_ITERATIONS", 8).to_i
end
