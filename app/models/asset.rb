class Asset < ApplicationRecord
  belongs_to :assetable, :polymorphic => true, optional: true
  delegate :url, to: :attachment
  do_not_validate_attachment_file_type :attachment

  include Concerns::Notify

  def to_email
    %{
      Document: #{self.email_link}<br/>
          Type: #{self.attachment_content_type}<br/><br/>
            On: <b>#{self.assetable.email_link}</b><br/> 
    }
  end

  def emails
    self.assetable.emails
  end

  def email_link
    %{<a href="http://#{Rails.application.secrets.domain_name}/#{self.attachment.url}" download>#{self.attachment_file_name}</a>}
  end
end
