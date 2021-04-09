module State
  extend ActiveSupport::Concern

  class InvalidStatusChange < StandardError; end

  included do
    enum status: {
      created: "created",
      started: "started",
      stopped: "stopped"
    }

    before_create do
      self.status = :created
    end
  end
end
