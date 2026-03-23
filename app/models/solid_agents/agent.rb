# frozen_string_literal: true

module SolidAgents
  class Agent < Record
    self.table_name = "solid_agents_agents"

    ROLES = %w[alex betty chad david eddy].freeze

    has_many :runs, class_name: "SolidAgents::Run", dependent: :nullify

    validates :key, :name, :runtime, presence: true
    validates :key, uniqueness: {scope: :environment}
    validates :role, inclusion: {in: ROLES}

    scope :enabled, -> { where(enabled: true) }
    scope :for_environment, ->(env) { where(environment: [nil, env.to_s]) }

    def runtime_sym
      runtime.to_sym
    end

    def capability?(name)
      capabilities_json.to_h.fetch(name.to_s, false)
    end
  end
end
