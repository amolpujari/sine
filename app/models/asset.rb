class Asset < ApplicationRecord
  include Concerns::Notify

  belongs_to :uploaded_by, class_name: 'User'

  belongs_to :assetable, :polymorphic => true, optional: true
  delegate :url, to: :attachment
  do_not_validate_attachment_file_type :attachment

  before_create :set_uuid
  after_create :mark_assetable_in_review

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def mark_assetable_in_review
    o = self.assetable
    return unless o.is_a? MarketingRequest

    unless o.complete?
      o.workflow_state = :in_review
      o.save
    end
  end

  def to_email
    %{
      <p>A new document uploaded by #{uploaded_by} to:</p>
      Request: <b>#{self.assetable.email_link}</b><br/>
    }
  end

  def emails
    self.assetable.emails + [self.uploaded_by.try(:email)]
  end

  def email_link
    %{<a href="#{self.attachment.expiring_url(1800)}">#{self.attachment_file_name}</a>}
  end
end
