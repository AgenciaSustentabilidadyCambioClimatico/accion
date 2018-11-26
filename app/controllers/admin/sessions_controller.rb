class Admin::SessionsController < Devise::SessionsController
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
    new_user_session_url
  end
end