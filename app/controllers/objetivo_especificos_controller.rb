class ObjetivoEspecificosController < ApplicationController
    before_action :set_objetivo_especifico, only: [:edit, :update]

    def new
      #binding.pry
        @objetivo_especifico = ObjetivosEspecifico.new
        respond_to do |format|
          format.html
          format.js
        end
	  end

    def create
      success = 'Objetivo Específico creado exitosamente.'

      custom_params = {
        objetivos_especifico: {
          flujo_id: params['flujo_id'],
          descripcion: params['descripcion'],
          metodologia: params['metodologia'],
          resultado: params['resultado'],
          indicadores: params['indicadores']
        }
      }

      @objetivo_especifico = ObjetivosEspecifico.new(custom_params[:objetivos_especifico])
      @tarea_pendiente = TareaPendiente.includes([:flujo]).find(@objetivo_especifico.flujo_id)
      @objetivo_especifico.flujo_id = @tarea_pendiente.flujo_id
      flujo_id = @tarea_pendiente.id
      respond_to do |format| 
        if @objetivo_especifico.save
          flash[:success] = success
          format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(flujo_id)}?tabs=propuesta-tecnica'" }
          format.html { redirect_to edit_fondo_produccion_limpia_path(flujo_id), notice: success }    
        else
          Rails.logger.debug 'ENTRO NOK'    
        end
      end
    end

    def destroy
      @objetivo_especifico = ObjetivosEspecifico.find(params[:id])
      if @objetivo_especifico.destroy
        flash[:success] = 'Objetivo Específico eliminado exitosamente.'
      else
        flash[:error] = 'Hubo un problema al eliminar el Objetivo Específico.'
      end
      redirect_to "#{request.referer}?tabs=propuesta-tecnica"
    end

    def edit
      @objetivo_especifico = ObjetivosEspecifico.find(params[:id])
      respond_to do |format|
        format.js
      end
    end
  
    def update
      success = 'Objetivo Específico actualizado exitosamente.'
      @tarea_pendiente = TareaPendiente.where(flujo_id:@objetivo_especifico.flujo_id, tarea_id: 109).first 
      @name_tab = '#propuesta-tecnica'
  
      custom_params = {
        objetivos_especifico: {
          id: params['id'],
          flujo_id: params['flujo_id'],
          descripcion: params['descripcion'],
          metodologia: params['metodologia'],
          resultado: params['resultado'],
          indicadores: params['indicadores']
        }
      }

      respond_to do |format|
        if @objetivo_especifico.update(custom_params[:objetivos_especifico])
          format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(@tarea_pendiente.id)}?tabs=propuesta-tecnica'" }
          format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
        else
          render 'edit'
        end
      end
    end


    def index
      @users = User.all
      respond_to do |format|
        format.html
        format.xml  { render :xml => @users}
        format.json { render :json => @users}
      end
    end

    private
    def set_objetivo_especifico
      @objetivo_especifico = ObjetivosEspecifico.find(params[:id])
    end

    def objetivo_especifico_params
      params.require(:objetivos_especifico).permit(:flujo_id, :descripcion, :metodologia, :resultado, :indicadores)
    end
    
end
