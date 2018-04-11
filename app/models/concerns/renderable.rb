module Concerns::Renderable
  extend ActiveSupport::Concern

  included do
    has_attached_file :attachment, :styles => {}
  end

  def public_name
    attachment_file_name
  end

  def data
    # if Rails.env.development?
      open(attachment.path)
    # else
    #   open(attachment.expiring_url(1800))
    # end
  end

  def render
    data.read
  end
end
