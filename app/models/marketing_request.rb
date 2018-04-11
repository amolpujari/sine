class MarketingRequest < ApplicationRecord
  default_scope { order('created_at DESC') }

  acts_as_commontable dependent: :destroy

  has_many :documents, :as => :assetable, :class_name => "Asset::Document", :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true

  include Workflow
  workflow do
    state :new
    state :in_review
    state :stale
    state :accepted
    state :rejected
    state :reopened

    on_error do |error, from, to, event, *args|
      logger.fatal "#{error.inspect} on #{from} -> #{to}"
    end
  end

  def self.completed_states
    @completed_states ||= ['accepted', 'rejected']
  end

  def self.mark_stale
    self.where('workflow_state != "stale" ').where('updated_at < ?', Date.today-5).update_all(workflow_state: 'stale')
  end

  def complete?
    self.class.completed_states.include? self.workflow_state
  end

  belongs_to :submitted_by, class_name: 'User'
end
