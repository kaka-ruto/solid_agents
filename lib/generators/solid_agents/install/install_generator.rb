# frozen_string_literal: true

module SolidAgents
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_schema
      template "db/agent_schema.rb"
    end

    def add_initializer
      template "config/initializers/solid_agents.rb"
    end

    def configure_environment
      insert_into_file Pathname(destination_root).join("config/environments/production.rb"), after: /^([ \t]*).*?(?=\nend)$/ do
        [
          "",
          '\\1# Configure Solid Agent',
          '\\1config.solid_agents.connects_to = { database: { writing: :solid_agents } }',
          '\\1config.solid_agents.default_runtime = :pi'
        ].join("\n")
      end
    end

    def ensure_migrations_directory
      empty_directory "db/agent_migrate"
      keep_path = Pathname(destination_root).join("db/agent_migrate/.gitkeep")
      return if keep_path.exist?

      create_file "db/agent_migrate/.gitkeep", "# Keep the SolidAgents migrations directory tracked by Git.\n"
    end
  end
end
