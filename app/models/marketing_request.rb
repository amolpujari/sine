class MarketingRequest < ApplicationRecord
  default_scope { order('marketing_requests.created_at DESC') }

  enum priority: [:P0, :P1, :P2, :P3, :P4]

  include Concerns::Notify
  include Workflow

  acts_as_commontable dependent: :destroy

  belongs_to :submitted_by, class_name: 'User'

  has_many :documents, :as => :assetable, :class_name => "Asset::Document", :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true
  validates_associated :documents, :on => :create

  validates :title, presence: true, length: { minimum: 10, maximum: 254 }
  validates :description, presence: true, length: { minimum: 10, maximum: 6000 }

  before_save :validate_watchers
  after_update :notify_if_completed, :notify_if_watchers_changed

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

  def to_email
    html = %{
      <p><b>#{self.email_link}</b></p>

      <p>Status: <b>#{self.workflow_state.upcase}</b></p>

      <p>#{self.description}</p>

      <p>Submitted by: #{self.submitted_by.to_s}</p>
    }

    if watchers.present?
      html << %{
      <p>Watchers: #{watchers}</p>
    }
    end

    html
  end

  def emails
    emails = [ self.submitted_by.email]
    emails += self.thread.comments.map{|c| c.creator.email} if self.thread
    emails += watchers_emails
    emails
  end

  def email_link
    %{<a href="http://#{Rails.application.secrets.domain_name}/marketing_requests/#{self.id}" target="_blank">#{self.title}</a>}
  end

  def notify_if_completed
    notify({ subject: "Request #{self.workflow_state}"
      }) if workflow_state_changed? && %w{reopened accepted rejected}.include?(workflow_state)
  end

  def notify_if_watchers_changed
    notify_admin({ subject: "Request watchers updated by owner"
      }) if watchers_changed?
  end

  def validate_watchers
    mails = self.watchers.to_s.split(/[\s,']/).map(&:strip).select do |mail|
      mail.match /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    end
    self.watchers = mails.join(',')
  end

  def all_documents
    @all_documents ||= [self.documents + self.thread.comments.map(&:documents) ].flatten.compact.sort_by(&:created_at).reverse
  end

  def self.completed_states
    @completed_states ||= ['accepted', 'rejected']
  end

  def self.mark_stale
    self.where('workflow_state != "stale" AND workflow_state != "accepted" ').where('updated_at < ?', Date.today-5).update_all(workflow_state: 'stale')
  end

  def complete?
    self.class.completed_states.include? self.workflow_state
  end

  def watchers_emails
    self.watchers.to_s.split(',')
  end
end
