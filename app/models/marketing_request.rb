class MarketingRequest < ApplicationRecord
  default_scope { order('created_at DESC') }

  acts_as_commontable dependent: :destroy

  include Workflow
  workflow do
    state :open
    state :in_review
    state :stale
    state :complete

    on_error do |error, from, to, event, *args|
      logger.fatal "#{error.inspect} on #{from} -> #{to}"
    end
  end

  belongs_to :submitted_by, class_name: 'User'
end
