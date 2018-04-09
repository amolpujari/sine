class MarketingRequest < ApplicationRecord
  default_scope { order('created_at DESC') }

  acts_as_commontable dependent: :destroy

  has_many :documents, :as => :assetable, :class_name => "Asset::Document", :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true

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
