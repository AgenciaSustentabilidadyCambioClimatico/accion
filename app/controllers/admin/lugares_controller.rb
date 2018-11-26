class Admin::LugaresController < ApplicationController
	def index
	end
	def search
	   pais = params[:pais]
	   region = params[:region]
	   provincia = params[:provincia]
	   comuna = params[:comuna]
	   @errors = false
	   @comunas = []
	   @paises = []
	   @regiones = []
	   @provincias = []
	   @resultado_mostrados = 25
    	@filtro_utilizado = []
	    
	   # verifica la existencia de una variable, de existir concatena la consulta anterior	   
	   if pais.present?
	   	paises = Pais.where("nombre ILIKE ?", "%#{pais}%").vigente?
	   	regiones = Region.where(pais_id: paises.pluck(:id)).where(vigente: true)
	   	provincias = Provincia.where(region_id: regiones.pluck(:id)).where(vigente: true)
	   	@comunas = Comuna.where(provincia_id: provincias.pluck(:id)).where(vigente: true)

	   	@filtro_utilizado << "Paìs: #{pais}"
	   end
	   if region.present?
	   	if pais.present?
	   		regiones = regiones.where("nombre ILIKE ?", "%#{region}%")
	   	else
	   		regiones = Region.where("nombre ILIKE ?", "%#{region}%")
	   	end
	   	provincias = Provincia.where(region_id: regiones.pluck(:id)).where(vigente: true)
	   	@comunas = Comuna.where(provincia_id: provincias.pluck(:id)).where(vigente: true)

	   	@filtro_utilizado << "Región: #{region}"
	   end	  
	   if provincia.present?
	   	if region.present?|| pais.present?
	   		provincias = provincias.where("nombre ILIKE ?", "%#{provincia}%")
	   	else
	   		provincias = Provincia.where("nombre ILIKE ?", "%#{provincia}%").where(vigente: true)
	   	end
	   	@comunas = Comuna.where(provincia_id: provincias.pluck(:id)).where(vigente: true)

	   	@filtro_utilizado << "Provincia: #{provincia}"
	   end 	   
	   if comuna.present?
	   	if provincia.present? || region.present? || pais.present?
	   		comunas = @comunas.where("nombre ILIKE ?", "%#{comuna}%")
	   	else
	   		comunas = Comuna.where("nombre ILIKE ?", "%#{comuna}%").where(vigente: true)
	   	end
	   	@comunas=comunas

	   	@filtro_utilizado << "Comuna: #{comuna}"
	   end
	   @paises = paises unless region.present? || provincia.present? || comuna.present?
	   @regiones =regiones unless provincia.present? || comuna.present?
	   @provincias = provincias unless comuna.present?

	   #parsear filtros
	   if !@filtro_utilizado.empty?
        @filtro_utilizado = @filtro_utilizado.join(', ')
      end
	end
	def new
		@lugar = []
	end
	def create
		if params[:pais].present?
			nombre = params.permit(:pais)
			@pais = Pais.new
			@pais.nombre = nombre[:pais]
			respond_to do |format|
				if @pais.save
					format.js { flash[:success] = 'Paìs correctamente creado.' }
					format.html { redirect_to admin_lugares_path, notice: 'Paìs correctamente creado.' }
				else
				   format.html { render :new }
				   format.js { flash[:error] = "Error al crear." }
				end
			end
		elsif params[:region].present?
			region = params.permit(:pais_id, :region)
			@region = Region.new
			@region.nombre = region[:region]
			@region.pais_id = region[:pais_id]
			respond_to do |format|
				if @region.save
					format.js { flash[:success] = 'Region correctamente creada.' }
					format.html { redirect_to admin_lugares_path, notice: 'Region correctamente creada.' }
				else
				   format.html { render :new }
				   format.js { flash[:error] = "Error al crear." }
				end
			end
		elsif params[:provincia].present?
			provincia = params.permit(:region_id, :provincia)
			@provincia = Provincia.new
			@provincia.nombre = provincia[:provincia]
			@provincia.region_id = provincia[:region_id]
			respond_to do |format|
				if @provincia.save
					format.js { flash[:success] = 'provincia correctamente creada.' }
					format.html { redirect_to admin_lugares_path, notice: 'provincia correctamente creada.' }
				else
				   format.html { render :new }
				   format.js { flash[:error] = "Error al crear." }
				end
			end
		elsif params[:comuna].present?
			comuna = params.permit(:provincia_id, :comuna)
			@comuna = Comuna.new
			@comuna.nombre = comuna[:comuna]
			@comuna.provincia_id = comuna[:provincia_id]
			respond_to do |format|
				if @comuna.save
					format.js { flash[:success] = 'comuna correctamente creada.' }
					format.html { redirect_to admin_lugares_path, notice: 'comuna correctamente creada.' }
				else
				   format.html { render :new }
				   format.js { flash[:error] = "Error al crear." }
				end
			end
		end
	end

	def edit
		if params[:tipo] == "1"
			@pais = Pais.find(params[:id])
			@lugar = { 
				pais_nombre: @pais.nombre, 
				pais: @pais.id
			}
		elsif params[:tipo] == "2"
			@region = Region.find(params[:id])
			@lugar = { 
				pais_nombre: @region.pais.nombre,
				pais: @region.pais.id,
				region_nombre: @region.nombre,
				region: @region.id
			}
		elsif params[:tipo] == "3"
			@provincia = Provincia.find(params[:id])
			@lugar = { 
				pais_nombre: @provincia.region.pais.nombre,
				pais: @provincia.region.pais.id,
				region_nombre: @provincia.region.nombre,
				region: @provincia.region.id,
				provincia_nombre: @provincia.nombre,
				provincia: @provincia.id
			}
		elsif params[:tipo] == "4"
			@comuna = Comuna.find(params[:id])	
			@lugar = { 
				pais_nombre: @comuna.provincia.region.pais.nombre,
				pais: @comuna.provincia.region.pais.id, 
				region_nombre: @comuna.provincia.region.nombre,
				region: @comuna.provincia.region.id,
				provincia_nombre: @comuna.provincia.nombre,
				provincia: @comuna.provincia.id,
				comuna_nombre: @comuna.nombre,
				comuna: @comuna.id
			}		
		end
  end

  def actualizar
  		if params[:seleccion].present?
  			seleccion = params[:seleccion]
  			if seleccion == "pais"
  				pais = Pais.find(params[:pais_original])
  				parametros = params.permit(:pais)
  				pais.nombre = parametros[:pais]
  				respond_to do |format|
			      if pais.save
			        format.js { flash[:success] = 'Paìs correctamente actualizado'
			          render js: "window.location='#{admin_lugares_path}'" }
			        format.html { redirect_to admin_lugares_path, notice: 'Paìs correctamente actualizado' }
			      else
			        format.html { render :edit }
			        format.js { flash[:error] = "Error al actualizar." }
			      end
			   end
			elsif seleccion == "region"
				region = Region.find(params[:region_original])
  				parametros = params.permit(:pais_id, :region)
  				region.nombre = parametros[:region]
  				region.pais_id = parametros[:pais_id]
  				respond_to do |format|
			      if region.save
			        format.js { flash[:success] = 'Región correctamente actualizada'
			          render js: "window.location='#{admin_lugares_path}'" }
			        format.html { redirect_to admin_lugares_path, notice: 'Región correctamente actualizada' }
			      else
			        format.html { render :edit }
			        format.js { flash[:error] = "Error al actualizar." }
			      end
			   end
			elsif seleccion == "provincia"
				provincia = Provincia.find(params[:provincia_original])
  				parametros = params.permit(:region_id, :provincia)
  				provincia.nombre = parametros[:provincia]
  				provincia.region_id = parametros[:region_id]
  				respond_to do |format|
			      if provincia.save
			        format.js { flash[:success] = 'Provincia correctamente actualizada'
			          render js: "window.location='#{admin_lugares_path}'" }
			        format.html { redirect_to admin_lugares_path, notice: 'Provincia correctamente actualizada' }
			      else
			        format.html { render :edit }
			        format.js { flash[:error] = "Error al actualizar." }
			      end
			   end
			elsif seleccion == "comuna"
				comuna = Comuna.find(params[:comuna_original])
  				parametros = params.permit(:provincia_id, :comuna)
  				comuna.nombre = parametros[:comuna]
  				comuna.provincia_id = parametros[:provincia_id]
  				respond_to do |format|
			      if comuna.save
			        format.js { flash[:success] = 'Comuna correctamente actualizada'
			          render js: "window.location='#{admin_lugares_path}'" }
			        format.html { redirect_to admin_lugares_path, notice: 'Comuna correctamente actualizada' }
			      else
			        format.html { render :edit }
			        format.js { flash[:error] = "Error al actualizar." }
			      end
			   end
  			end
  		end
  end


  	def destroy
  		if params[:tipo].present?
  			seleccion = params[:tipo]
  			if seleccion == "1"
  				pais = Pais.find(params[:id])
				pais.vigente = false
				if pais.save
					pais.regiones.each do |region|
						region.vigente = false
						region.save
						#desactivar provincias asociadas
						region.provincias.each do |provincia|
							provincia.vigente = false
							provincia.save
							#deasctivar comunas asociadas
							provincia.comunas.each do |comuna|
								comuna.vigente = false
								comuna.save
							end
						end
					end
		        	redirect_to admin_lugares_url, notice: 'Paìs correctamente eliminado.'
		      else
		        redirect_to admin_lugares_url, notice: 'Paìs no ha podido ser eliminado.'
		      end
			elsif seleccion == "2"
				region = Region.find(params[:id])
				region.vigente = false
				if region.save
					#desactivar provincias asociadas
					region.provincias.each do |provincia|
						provincia.vigente = false
						provincia.save
						#deasctivar comunas asociadas
						provincia.comunas.each do |comuna|
							comuna.vigente = false
							comuna.save
						end
					end
		        redirect_to admin_lugares_url, notice: 'Región correctamente eliminado.'
		      else
		        redirect_to admin_lugares_url, notice: 'Región no ha podido ser eliminado.'
		      end
			elsif seleccion == "3"
				provincia = Provincia.find(params[:id])
				provincia.vigente = false
				if provincia.save
					#deasctivar comunas asociadas
					provincia.comunas.each do |comuna|
						comuna.vigente = false
						comuna.save
					end
		        redirect_to admin_lugares_url, notice: 'Provincia correctamente eliminado.'
		      else
		        redirect_to admin_lugares_url, notice: 'Provincia no ha podido ser eliminado.'
		      end
			elsif seleccion == "4"
				comuna = Comuna.find(params[:id])
				comuna.vigente = false
				if comuna.save
		        redirect_to admin_lugares_url, notice: 'Comuna correctamente eliminado.'
		      else
		        redirect_to admin_lugares_url, notice: 'Comuna no ha podido ser eliminado.'
		      end
			end
		end
	end

	#obtener lugares
	def get_regiones
	   @pais = Pais.find params[:pais_id]
	   @regiones = @pais.regiones.order('nombre').vigente?
	end

	def get_provincias
	   @region = Region.find params[:region_id]
	   @provincias = @region.provincias.order('nombre').vigente?
	end

	def get_comunas
	   @provincia = Provincia.find params[:provincia_id]
	   @comunas = @provincia.comunas.order('nombre').vigente?
	end

	private
	def set_lugar
      @lugar = Lugar.find(params[:id])
   end
   def lugares_params
		params.require(:pais).permit(:pais_n)
	end
	def pais_params
      params.permit(
        :pais,
        :pais_id
      )
   end
   def region_params
      params.permit(
        :region,
        :region_id
      )
   end
   def provincia_params
      params.permit(
        :provincia,
        :provincia_id
      )
   end
   def comuna_params
      params.permit(
        :comuna,
        :comuna_id
      )
   end
end
