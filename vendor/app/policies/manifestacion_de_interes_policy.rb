class ManifestacionDeInteresPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
  	es_proponente = false
    if @user.is_admin?
    	es_proponente = true
    elsif @user.personas.size
    	@user.personas.each do |persona|
    		if persona.es_proponente?
    			es_proponente = true
    			break
    		end
    	end
    end
    es_proponente
  end
end