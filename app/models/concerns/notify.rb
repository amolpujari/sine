module Concerns::Notify
  extend ActiveSupport::Concern

  included do
    after_create :notify_after_create
  end

  def notify_after_create options={}
    options[:subject] = "New #{self.class.name.demodulize.tableize.singularize.humanize}"
    ApplicationMailer.delay.notify(self, options)
  end

  def notify options={}
    ApplicationMailer.delay.notify(self, options)
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
