# frozen_string_literal: true

module SolidAgents
  module Agents
    class David < Base
      def initialize(run:, context:)
        super(run: run, context: context, owner: "david")
      end
    end
  end
end
