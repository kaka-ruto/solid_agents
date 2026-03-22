# frozen_string_literal: true

module SolidAgents
  class Record < ActiveRecord::Base
    self.abstract_class = true

    connects_to(**SolidAgents.connects_to) if SolidAgents.connects_to
  end
end

ActiveSupport.run_load_hooks :solid_agents_record, SolidAgents::Record
