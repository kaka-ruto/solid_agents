# frozen_string_literal: true

module SolidAgents
  module Runs
    class ContextBuilder
      def self.call(source:)
        if source.respond_to?(:attributes)
          source.attributes.slice("id", "message", "class_name", "backtrace", "context")
        else
          {value: source.to_s}
        end
      end
    end
  end
end
