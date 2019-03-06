class Admin::VariablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variable, only: [:edit, :update, :destroy]

  def index
    @variables = Variable.order(id: :asc).all
  end

  def new
    @variable = Variable.new
  end

  def edit
  end

  def create
    @variable = Variable.new(create_variable_params)
    respond_to do |format|
      if @variable.save
        success = t(:m_successfully_created, m: t(:variable).downcase)
        format.js { 
          flash.now[:success] = success
          @variable = Variable.new
        }
        format.html { redirect_to admin_variables_url, notice: success }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @variable.update(update_variable_params)
        success = t(:m_successfully_updated, m: t(:variable).downcase)
        format.js { flash.now[:success] = success }
        format.html { redirect_to admin_variables_url, notice: success }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  private
    def set_variable
      @variable = Variable.find(params[:id])
    end
    
    def create_variable_params
      params.require(:variable).permit(
        :nombre,
        :valor
      )
    end

    def update_variable_params
      params.require(:variable).permit(
        :valor
      )
    end
end
