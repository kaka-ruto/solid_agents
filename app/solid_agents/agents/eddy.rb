# frozen_string_literal: true

module SolidAgents
  module Agents
    class Eddy < Base
      def initialize(run:, context:)
        super(run: run, context: context, owner: "eddy")
      end
    end
  end
end
