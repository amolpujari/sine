class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  include ApplicationHelper

  default from: "Sine <info@sine>", cc: [Rails.application.secrets.notify[:cc].to_s.split(',')].flatten.compact.map(&:to_s).map(&:strip).uniq
  layout 'mailer'

  def notify record, options={}
    @record = record
    
    @subject = if options[:subject]
      "Sine: #{options[:subject]}"
    else
      "Sine: about #{record.class.name.demodulize.tableize.singularize.humanize}"
    end

    @body = options.delete(:body) || @record.to_email    
    
    mail(to: [record.emails].flatten.compact.map(&:to_s).map(&:strip).uniq, 
      subject: @subject
    )
  end
end
