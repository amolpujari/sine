module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin!

    def authenticate_admin!
      warden.authenticate!
      redirect_to root_path unless current_user.admin?
    end
  end
end
