class ObjetivoEspecificosController < ApplicationController
    before_action :set_objetivo_especifico, only: [:edit, :update]

    def new
        @objetivo_especifico = ObjetivosEspecifico.new
        
	  end

    def create
      success = 'Objetivo Específico creado exitosamente.'
      @objetivo_especifico = ObjetivosEspecifico.new(objetivo_especifico_params)
      #binding.pry
      @tarea_pendiente = TareaPendiente.includes([:flujo]).find(@objetivo_especifico.flujo_id)
      @objetivo_especifico.flujo_id = @tarea_pendiente.flujo_id
      flujo_id = @tarea_pendiente.id
      respond_to do |format|
        if @objetivo_especifico.save
          flash[:success] = success
          format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(flujo_id)}'"}
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
    end
  
    def update
      success = 'Objetivo Específico actualizado exitosamente.'
      @tarea_pendiente = TareaPendiente.where(flujo_id:@objetivo_especifico.flujo_id, tarea_id: 109).first 
      @name_tab = '#propuesta-tecnica'

      respond_to do |format|
        if @objetivo_especifico.update(objetivo_especifico_params)
          format.js { render js: "window.location='#{edit_fondo_produccion_limpia_path(@tarea_pendiente.id)}'"}
          format.html { redirect_to edit_fondo_produccion_limpia_path(@tarea_pendiente.id), notice: success }
          format.json {
            #render json: { success: success, data: { activeTab: @name_tab } }
            render(:json => @name_tab.to_json, :content_type => 'application/json',
            :layout => false)
          }
          
        else
          render 'edit'
        end
      end
    end


    def index
      @users = User.all
      respond_to do |format|
        format.html # index.html.erb
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
