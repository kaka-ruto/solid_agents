# frozen_string_literal: true

require_relative "lib/solid_agents/version"

Gem::Specification.new do |spec|
  spec.name = "solid_agents"
  spec.version = SolidAgents::VERSION
  spec.authors = ["Kaka Ruto"]
  spec.email = ["kr@kakaruto.com"]

  spec.summary = "Database-backed Rails AI agent runtime bridge"
  spec.description = "Solid Agent stores agent runs in its own database and dispatches staged workflow tasks to the pi runtime with a built-in Rails UI."
  spec.homepage = "https://github.com/kaka-ruto/solid_agents"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "README.md", "CHANGELOG.md", "Rakefile", "LICENSE.txt"]
  end

  rails_version = ">= 6.1"
  spec.add_dependency "actionpack", rails_version
  spec.add_dependency "actionview", rails_version
  spec.add_dependency "activejob", rails_version
  spec.add_dependency "activerecord", rails_version
  spec.add_dependency "activesupport", rails_version
  spec.add_dependency "railties", rails_version

  spec.add_development_dependency "sqlite3", ">= 2.0"
end
