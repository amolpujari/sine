class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  include ApplicationHelper

  default from: "OffSpring <info@platformv.com>", cc: [Rails.application.secrets.notify[:cc].to_s.split(',')].flatten.compact.map(&:to_s).map(&:strip).uniq
  layout 'mailer'

  def notify record, options={}
    @record = record

    @subject = if options[:subject]
      "OffSpring: #{options[:subject]}"
    else
      "OffSpring: about #{record.class.name.demodulize.tableize.singularize.humanize}"
    end

    @body = options.delete(:body) || @record.to_email

    to_emails = options.delete(:to) || record.emails

    mail(to: [to_emails].flatten.compact.map(&:to_s).map(&:strip).uniq,
      subject: @subject
    )
  end
end
