class NotaRegistroProveedorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if usuario_autorizado?
        scope.all
      else
        scope.none
      end
    end

    private

    def usuario_autorizado?
      return false if user.blank?

      user.is_admin? ||
        (user.respond_to?(:is_admin_no_agencia?) && user.is_admin_no_agencia?) ||
        (user.respond_to?(:posee_rol_ascc?) && (user.posee_rol_ascc?(Rol::JEFE_DE_LINEA) || user.posee_rol_ascc?(Rol::REVISOR_TECNICO)))
    end
  end

  def index?
    usuario_autorizado?
  end

  def show?
    usuario_autorizado?
  end

  def edit?
    evaluar?
  end

  def update?
    evaluar?
  end

  def evaluacion?
    evaluar?
  end

  def evaluar?
    usuario_autorizado?
  end

  private

  def usuario_autorizado?
    # Retorna false si no hay usuario (anónimo), evitando NoMethodError
    return false if user.blank?

    user.is_admin? ||
      (user.respond_to?(:is_admin_no_agencia?) && user.is_admin_no_agencia?) ||
      (user.respond_to?(:posee_rol_ascc?) && (user.posee_rol_ascc?(Rol::JEFE_DE_LINEA) || user.posee_rol_ascc?(Rol::REVISOR_TECNICO)))
  end
end