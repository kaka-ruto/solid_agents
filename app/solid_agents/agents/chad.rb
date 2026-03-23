# frozen_string_literal: true

module SolidAgents
  module Agents
    class Chad < Base
      def initialize(run:, context:)
        super(run: run, context: context, owner: "chad")
      end
    end
  end
end
