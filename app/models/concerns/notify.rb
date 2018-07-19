module Concerns::Notify
  extend ActiveSupport::Concern

  included do
    after_create :notify_after_create
  end

  def notify_after_create options={}
    options[:subject] = "New #{self.class.name.demodulize.tableize.singularize.humanize}"
    ApplicationMailer.notify(self, options).deliver
  end

  def notify options={}
    ApplicationMailer.notify(self, options).deliver
  end

  def notify_admin options={}
    options[:to] = User.admin.pluck(:email)
    ApplicationMailer.notify(self, options).deliver
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
