class Admin::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  respond_to :html, :js
  before_action :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:user){|u| u.permit(
      :nombre_completo,
      :telefono,
      :email,
      :web_o_red_social_1,
      :web_o_red_social_2,
      :fields_visibility,
      :current_password,
      :password,
      :password_confirmation
    )}
  end
  
  def edit
  	super
  end

  def update
    super
  end
end