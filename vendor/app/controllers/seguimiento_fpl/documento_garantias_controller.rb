class SeguimientoFpl::DocumentoGarantiasController < ApplicationController
  before_action :authenticate_user!
  before_action :cargar_tarea_pendiente
  before_action :cargar_datos, except: [:edit, :update]
  before_action :cargar_doc, only: [:edit, :update, :destroy]

  def index
    @doc_garantia = DocumentoGarantia.new
  end

  def edit
    @url = seguimiento_fpl_proyecto_documento_garantia_path(@tarea_pendiente, @proyecto, @doc_garantia)
  end

  def new
    @url = seguimiento_fpl_proyecto_documento_garantias_path(@tarea_pendiente, @proyecto)
    @doc_garantia = DocumentoGarantia.new
  end

  def create
    @url = seguimiento_fpl_proyecto_documento_garantias_path(@tarea_pendiente, @proyecto)
    @doc_garantia = DocumentoGarantia.new(doc_garantia_params)
    respond_to do |format|
      if @doc_garantia.save
        if @doc_garantia.tipo_documento_garantia_id == 4
          @doc_garantia.documento_garantia.update({
            fecha_vencimiento: @doc_garantia.fecha_vencimiento,
            fecha_vencimiento_original: @doc_garantia.documento_garantia.fecha_vencimiento
          })
        end
        format.html { redirect_to new_seguimiento_fpl_proyecto_documento_garantia_path(@tarea_pendiente,@proyecto), notice: "Documento garantía creado" }
        format.js { 
          flash.now[:success] = "Documento garantía creado"
          @doc_garantia = DocumentoGarantia.new
        }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    @url = seguimiento_fpl_proyecto_documento_garantia_path(@tarea_pendiente, @proyecto, @doc_garantia)
    respond_to do |format|
      if @doc_garantia.update(doc_garantia_params)
        if @doc_garantia.tipo_documento_garantia_id == 4
          @doc_garantia.documento_garantia.update({fecha_vencimiento: @doc_garantia.fecha_vencimiento})
        end
        format.html { redirect_to edit_seguimiento_fpl_proyectos_documento_garantia_path(@tarea_pendiente,@proyecto,@doc_garantia), notice: "Documento garantia actualizado" }
        format.js { 
          flash.now[:success] = "Documento garantía actualizado"
        }
      else
        format.html { render :edit }
        format.js {  }
      end
    end
  end

  def destroy

    if @doc_garantia.tipo_documento_garantia_id == 4
      @doc_garantia.documento_garantia.update({
        fecha_vencimiento: @doc_garantia.documento_garantia.fecha_vencimiento_original,
        fecha_vencimiento_original: nil
      })
    end
    @doc_garantia.destroy
    respond_to do |format|
      format.html { redirect_to seguimiento_fpl_proyecto_documento_garantias_path(@tarea_pendiente,@proyecto,@doc_garantia), notice: "Documento garantia eliminado" }
      format.js { 
        flash.now[:success] = "Documento garantía eliminado"
      }
    end

  end

  private
    def doc_garantia_params
      parametros = params.require(:documento_garantia).permit(
        :proyecto_id,
        :tipo_documento_garantia_id,
        :documento_garantia_id,
        :numero_documento,
        :monto,
        :fecha_vencimiento,
        :fecha_vencimiento_original,
        :archivo,
        :estado_documento_garantia_id,
        :archivo_cache
      )
      parametros[:monto] = dinero_params(parametros[:monto]) unless parametros[:monto].blank?
      parametros
    end

    def cargar_datos id=nil
      id_proyecto = (id.nil?) ? params[:proyecto_id] : id
      @proyecto = Proyecto.includes(:documento_garantias).find(id_proyecto)
      doc_garantia_ultimo = @proyecto.documento_garantias.order("fecha_vencimiento DESC").first
      @ultima_fecha = (doc_garantia_ultimo.blank?) ? "" : doc_garantia_ultimo.fecha_vencimiento.blank? ? "" : l(doc_garantia_ultimo.fecha_vencimiento, format: '%d-%m-%Y')
      @monto_mes = @proyecto.documento_garantias.where("fecha_vencimiento >= ?", Date.today + 1.month).where(estado_documento_garantia_id: nil).sum(:monto)
    end

    def cargar_doc
      @doc_garantia = DocumentoGarantia.includes(:proyecto).find(params[:id])
      cargar_datos @doc_garantia.proyecto.id
    end

    def cargar_tarea_pendiente
      @tarea_pendiente = TareaPendiente.find(params[:tarea_pendiente])
      autorizado? @tarea_pendiente
    end

end