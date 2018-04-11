module Concerns::NotifyAfterCreate
  extend ActiveSupport::Concern

  included do
    after_create :notify_after_create
  end

  def notify_after_create
    ApplicationMailer.notify_after_create(self).deliver
  end

  def to_email
    'Not Defined!'
  end

  def email_link
    'Not Defined!'
  end

  def emails
    []
  end
end
