class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  include ApplicationHelper

  default from: "Sine <info@sine>"
  layout 'mailer'

  def notify_after_create record
    @record = record
    mail(to: [record.emails].flatten.compact.map(&:to_s).map(&:strip).uniq, 
      cc: [Rails.application.secrets.notify[:after_create].to_s.split(',')].flatten.compact.map(&:to_s).map(&:strip).uniq,
      subject: "Sine: New #{record.class.name.demodulize.tableize.singularize.humanize}"
    )
  end
end
