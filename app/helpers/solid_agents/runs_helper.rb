# frozen_string_literal: true

module SolidAgents
  module RunsHelper
    def status_badge_class(status)
      case status
      when "succeeded" then "ok"
      when "failed" then "err"
      when "running" then "run"
      else "muted"
      end
    end
  end
end
