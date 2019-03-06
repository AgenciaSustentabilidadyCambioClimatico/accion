class Admin::InvitationsController < Devise::InvitationsController
  prepend_before_action :require_no_authentication, :only => [:update]

  # PUT /resource/invitation
  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    self.resource = accept_resource
    invitation_accepted = resource.errors.empty?

    yield resource if block_given?
    respond_to do |format|
      if invitation_accepted
        if Devise.allow_insecure_sign_in_after_accept
          flash_message = resource.active_for_authentication? ? "Invitación aceptada, ya te encuentras dentro del sistema." : "Invitación aceptada, comuníquese con el administrador para inciar sesión."
          sign_in(resource_name, resource)
          format.html{ redirect_to after_accept_path_for(resource), notice: flash_message }
        else
          format.html{ redirect_to new_session_path(resource_name), notice: "Invitación aceptada" }
        end
      else
        resource.invitation_token = raw_invitation_token
        format.html {render :edit}
      end
    end
  end


  def after_accept_path_for(resource)
    resource.session = {}
    personas = resource.personas.map{|m|m}.compact
    cargos = personas.map{|p|p.persona_cargos.map{|cp| cp.cargo_id}}
    resource.session[:cargos] = cargos.blank? ? [] : cargos[0]
    resource.session[:personas] = personas.blank? ? [] : personas.map{|p|p.attributes.to_json.as_hash}
    resource.save
    root_path
  end

  protected

  def update_resource_params
    devise_parameter_sanitizer.sanitize(:accept_invitation)
  end
end