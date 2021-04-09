module State
  extend ActiveSupport::Concern

  class InvalidStatusChange < StandardError; end

  STATUSES = {
    created: "created",
    started: "started",
    stopped: "stopped"
  }

  included do
    before_create { self.status = :created }
  end
end
