# frozen_string_literal: true

module SolidAgents
  module Agents
    class Betty < Base
      def initialize(run:, context:)
        super(run: run, context: context, owner: "betty")
      end
    end
  end
end
