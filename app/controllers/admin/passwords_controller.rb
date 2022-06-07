class Admin::PasswordsController < Devise::PasswordsController

  def new

    @header = ReporteriaDato.find_by(ruta: nil)
    self.resource = resource_class.new
  end

  def create

    @header = ReporteriaDato.find_by(ruta: nil)
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_to do |format|
        format.html{
          respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
        }
        format.js{
          @correcto = true
        }
      end
    else
      respond_to do |format|
        format.html{
          flash[:danger] = "Error al enviar correo"
          respond_with(resource)
        }
        format.js{
          @correcto = false
        }
      end
    end
  end

  def edit
    @header = ReporteriaDato.find_by(ruta: nil)
    super
  end

  def update

    @header = ReporteriaDato.find_by(ruta: nil)
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      flash[:danger] = "Error al actualizar contraseña"
      set_minimum_password_length
      respond_with resource
    end
  end
end