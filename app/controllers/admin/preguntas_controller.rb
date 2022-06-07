class Admin::PreguntasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pregunta, only: [:show, :edit, :update, :destroy]

  def index
    @preguntas = Pregunta.order(id: :desc).all
    @pregunta  = Pregunta.new
  end

  def new
    @pregunta = Pregunta.new({base: false})
  end

  def edit
  end

  def create
    @pregunta = Pregunta.new(pregunta_params)
    respond_to do |format|
      if @pregunta.save
        @pregunta = Pregunta.new({base: false})
        format.js { 
          flash.now[:success] = 'Pregunta correctamente creada.'
        }
        format.html { redirect_to new_admin_pregunta_url, notice: 'Pregunta correctamente creada.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @pregunta.update(pregunta_params)
        format.js { flash.now[:success] = 'Pregunta correctamente actualizada.' }
        format.html { redirect_to edit_admin_pregunta_url(@pregunta), notice: 'Pregunta correctamente actualizada.' }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    begin
      @pregunta.destroy
      redirect_to admin_preguntas_url, notice: 'Pregunta correctamente eliminada.'
    rescue
      redirect_to admin_preguntas_url, alert: 'Pregunta no puede ser eliminada porque está siendo utilizada en una encuesta.'
    end
  end

  private
    def set_pregunta
      @pregunta = Pregunta.find(params[:id])
    end

    def pregunta_params
      params.require(:pregunta).permit(
        :texto,
        :tipo_respuestas,
        :base
      )
    end
end