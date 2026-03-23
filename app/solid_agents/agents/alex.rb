# frozen_string_literal: true

module SolidAgents
  module Agents
    class Alex < Base
      def initialize(run:, context:)
        super(run: run, context: context, owner: "alex")
      end
    end
  end
end
