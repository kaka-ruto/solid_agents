# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative "dummy/config/environment"
require "rails/test_help"
require "solid_agents"
require "fileutils"

ActiveJob::Base.queue_adapter = :test

storage_dir = File.expand_path("dummy/storage", __dir__)
FileUtils.mkdir_p(storage_dir)

# The test sqlite database may already exist from older table names.
# Recreate it on boot so migrations always apply against the current schema.
db_config = ActiveRecord::Base.connection_db_config
if db_config&.adapter == "sqlite3"
  db_path = db_config.database
  db_path = Rails.root.join(db_path).to_s unless File.absolute_path(db_path) == db_path
  ActiveRecord::Base.connection_pool.disconnect!
  FileUtils.rm_f(db_path)
  ActiveRecord::Base.establish_connection
end

migration_paths = [File.expand_path("dummy/db/migrate", __dir__)]
ActiveRecord::Migration.verbose = false
ActiveRecord::MigrationContext.new(migration_paths).migrate

class ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    SolidAgents::Artifact.delete_all
    SolidAgents::RunEvent.delete_all
    SolidAgents::Run.delete_all
    SolidAgents::Agent.delete_all
    SolidAgents::Config.delete_all
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    ActiveJob::Base.queue_adapter.performed_jobs.clear
  end
end
