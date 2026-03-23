# frozen_string_literal: true

ActiveRecord::Schema[6.1].define do
  create_table :solid_agents_agents, force: :cascade do |t|
    t.string :key, null: false
    t.string :name, null: false
    t.string :role, null: false, default: "alex"
    t.string :runtime, null: false, default: "ruby_llm"
    t.boolean :enabled, null: false, default: true
    t.string :environment
    t.string :model
    t.text :system_prompt
    t.json :capabilities_json, default: {}
    t.string :working_directory
    t.integer :timeout_seconds, null: false, default: 900
    t.integer :max_iterations, null: false, default: 8
    t.timestamps
  end

  add_index :solid_agents_agents, [:key, :environment], unique: true

  create_table :solid_agents_runs, force: :cascade do |t|
    t.references :agent, null: false, foreign_key: {to_table: :solid_agents_agents}
    t.string :external_key
    t.string :source_type, null: false
    t.bigint :source_id
    t.string :error_fingerprint
    t.string :status, null: false, default: "queued"
    t.string :stage, null: false, default: "received"
    t.string :stage_owner, null: false, default: "alex"
    t.string :runtime, null: false, default: "ruby_llm"
    t.string :environment, null: false
    t.string :repo_path
    t.string :base_branch
    t.string :work_branch
    t.string :commit_sha
    t.string :pr_url
    t.integer :pr_number
    t.string :test_command
    t.integer :attempt_count, null: false, default: 0
    t.integer :max_iterations
    t.datetime :started_at
    t.datetime :finished_at
    t.json :prompt_payload, default: {}
    t.json :result_payload, default: {}
    t.json :error_payload, default: {}
    t.timestamps
  end

  add_index :solid_agents_runs, :external_key, unique: true
  add_index :solid_agents_runs, :status
  add_index :solid_agents_runs, :stage
  add_index :solid_agents_runs, :error_fingerprint
  add_index :solid_agents_runs, [:source_type, :source_id]

  create_table :solid_agents_work_items, force: :cascade do |t|
    t.references :run, null: false, foreign_key: {to_table: :solid_agents_runs}
    t.string :column_key, null: false, default: "received"
    t.string :title, null: false
    t.text :summary
    t.json :metadata_json, default: {}
    t.timestamps
  end

  add_index :solid_agents_work_items, :column_key

  create_table :solid_agents_handoffs, force: :cascade do |t|
    t.references :run, null: false, foreign_key: {to_table: :solid_agents_runs}
    t.string :stage, null: false
    t.string :from_agent, null: false
    t.string :to_agent, null: false
    t.text :note
    t.json :payload, default: {}
    t.timestamps
  end

  add_index :solid_agents_handoffs, [:run_id, :stage]

  create_table :solid_agents_run_events, force: :cascade do |t|
    t.references :run, null: false, foreign_key: {to_table: :solid_agents_runs}
    t.string :event_type, null: false
    t.datetime :event_time, null: false
    t.text :message, null: false
    t.string :actor
    t.json :payload, default: {}
    t.integer :sequence, null: false
    t.timestamps
  end

  add_index :solid_agents_run_events, [:run_id, :sequence], unique: true
  add_index :solid_agents_run_events, :event_type

  create_table :solid_agents_artifacts, force: :cascade do |t|
    t.references :run, null: false, foreign_key: {to_table: :solid_agents_runs}
    t.string :kind, null: false
    t.string :label
    t.string :storage_type, null: false
    t.string :storage_ref
    t.text :content_text
    t.json :content_json, default: {}
    t.string :sha256
    t.bigint :byte_size
    t.timestamps
  end

  add_index :solid_agents_artifacts, :kind

  create_table :solid_agents_configs, force: :cascade do |t|
    t.string :key, null: false
    t.string :environment
    t.json :value_json, default: {}
    t.timestamps
  end

  add_index :solid_agents_configs, [:key, :environment], unique: true
end
