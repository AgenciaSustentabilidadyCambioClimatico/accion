class Admin::CargasHistoricasController < ApplicationController
	before_action :authenticate_user!
	before_action :tengo_permiso

	def index
	end

	def carga_historica
		
		# DZC 2018-11-21 12:12:00 se modifica para manejar errores en multicarga de archivos
		# @resultados = ["Archivo invalido"]
		@resultados = []
		if params[:instrumentos].present?
			@resultados += helpers.validacion_data_historico_instrumento(params[:instrumentos], [:codigo, :nombre_instancia_instrumento])
		elsif params[:apl].present?
			@resultados += helpers.carga_data_historico_apl(params[:apl], params[:aplDocs])
		elsif params[:ppf].present?
			@resultados += helpers.carga_data_historico_ppf(params[:ppf], params[:ppfDocs])
		elsif params[:adhesion].present?
			@resultados += helpers.carga_data_historico_adhesiones(params[:adhesion], params[:adhesionDocs])
		elsif params[:actores].present?
			@resultados += helpers.carga_data_historico_actores(params[:actores])
		end
		respond_to do |format|
      if @resultados.blank?     
        format.js { flash[:success] = 'Carga historica finalizada correctamente'}
        format.html { redirect_to dato_productivo_elemento_adheridos_path(), notice: 'Carga historica finalizada correctamente' }
      else
        format.html { render :index }
        format.js { 
        	flash[:error] = @resultados
        }
      end
    end    
	end
	def formato_instrumento
		send_file("#{Rails.root}/app/assets/archivos_comunes/formato_instrumento.xlsx", filename: "formatoCargaHistoricaInstrumento.xlsx", type: "application/xlsx")
	end
	def formato_apl
		send_file("#{Rails.root}/app/assets/archivos_comunes/formato_apl.xlsx", filename: "formatoCargaHistoricaAPLs.xlsx", type: "application/xlsx")
	end
	def formato_ppf
		send_file("#{Rails.root}/app/assets/archivos_comunes/formato_ppf.xlsx", filename: "formatoCargaHistoricaPPFs.xlsx", type: "application/xlsx")
	end

	def formato_adhesion
		titulos = helpers.columnas_excel_adhesiones
    datos = []
    dominios = Adhesion.dominios(@ppp.present?)
    @ruta = "#{Rails.root}/public/uploads/carga_historica/formato"
    FileUtils.mkdir_p(@ruta) unless File.exist?(@ruta)
    @ruta += "formato_adhesion.xlsx"
    ExportaExcel.formato(@ruta, titulos, dominios, datos, "Adhesiones" )
    send_data File.open(@ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: "formatoCargaHistoricaAdhesion.xlsx"
  end

  def formato_actores
		titulos = helpers.columnas_excell_actores
    datos = []
    dominios = MapaDeActor.dominios
    @ruta = "#{Rails.root}/public/uploads/carga_historica/formato"
    FileUtils.mkdir_p(@ruta) unless File.exist?(@ruta)
    @ruta += "formato_mapa_actor.xlsx"
    ExportaExcel.formato(@ruta, titulos, dominios, datos, "MapaDeActor" )
    send_data File.open(@ruta).read, type: 'application/xslx', charset: "iso-8859-1", filename: "formatoCargaHistoricaMapaDeActores.xlsx"
  end

  private

	  def tengo_permiso
	  	unless current_user.is_admin?
	  		flash[:warning] = 'Usted no tiene permiso para manejar carga histórica'
	      redirect_to root_path
	  	end
	  end

end
