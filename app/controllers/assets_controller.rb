class AssetsController < ApplicationController
  before_action :authenticate_user!

  def document_download
    @document = Asset::Document.where(uuid: params[:uuid].to_s.strip).first!
    send_data @document.render, filename: @document.public_name, type: @document.attachment_content_type, disposition: 'attachment'
  end
end
