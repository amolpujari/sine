class MarketingRequest < ApplicationRecord
  include Workflow
  workflow do
    state :open
    state :in_progress
    state :stale
    state :complete

    on_error do |error, from, to, event, *args|
      logger.fatal "#{error.inspect} on #{from} -> #{to}"
    end
  end

  belongs_to :submitted_by, class_name: 'User'
end
