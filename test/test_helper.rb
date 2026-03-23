# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative "dummy/config/environment"
require "rails/test_help"
require "solid_agents"
require_relative "support_vcr"
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

  self.fixture_paths = [File.expand_path("fixtures", __dir__)]
  fixtures :all

  set_fixture_class(
    solid_agents_agents: "SolidAgents::Agent",
    solid_agents_runs: "SolidAgents::Run",
    solid_agents_run_events: "SolidAgents::RunEvent",
    solid_agents_artifacts: "SolidAgents::Artifact",
    solid_agents_work_items: "SolidAgents::WorkItem",
    solid_agents_handoffs: "SolidAgents::Handoff"
  )

  def fixture_id(name)
    ActiveRecord::FixtureSet.identify(name)
  end

  setup do
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    ActiveJob::Base.queue_adapter.performed_jobs.clear
  end
end
