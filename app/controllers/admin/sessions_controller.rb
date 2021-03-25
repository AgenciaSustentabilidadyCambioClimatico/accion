class Admin::SessionsController < Devise::SessionsController

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_to do |format|
      format.html {
        respond_with(resource, serialize_options(resource))
      }
      format.js
    end
  end

  # POST /resource/sign_in
  def create
    respond_to do |format|
      format.html {
        self.resource = warden.authenticate!(auth_options)
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)
      }
      format.js {
        begin
          self.resource = warden.authenticate(auth_options)
          sign_in(resource_name, resource)
          yield resource if block_given?
          flash[:notice] = t('devise.sessions.signed_in')
          @correcto = after_sign_in_path_for(resource) 
        rescue
          @correcto = false
          user_params = params.require(:user).permit(:rut, :password)
          self.resource = resource_class.new(user_params)
        end
      }
    end
  end

  def after_sign_in_path_for(resource)
  	resource.session = {}
    personas = resource.personas.map{|m|m}.compact
  	cargos = personas.map{|p|p.persona_cargos.map{|cp| cp.cargo_id}}
  	resource.session[:cargos] = cargos.blank? ? [] : cargos[0]
    resource.session[:personas] = personas.blank? ? [] : personas.map{|p|p.attributes.to_json.as_hash}
  	resource.save
    root_path
  end

  def after_sign_out_path_for(resource)
    root_url
  end
end