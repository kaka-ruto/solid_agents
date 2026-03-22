# frozen_string_literal: true

module SolidAgents
  class Config < Record
    self.table_name = "solid_agents_configs"

    validates :key, presence: true, uniqueness: {scope: :environment}

    def self.get(key, environment: Rails.env)
      row = where(key: key, environment: [environment, nil]).order(Arel.sql("environment IS NULL")).first
      row&.value_json
    end
  end
end
