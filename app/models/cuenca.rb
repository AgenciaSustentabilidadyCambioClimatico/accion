class Cuenca < ApplicationRecord
  validates :codigo_cuenca, presence: true
  validates :nombre_cuenca, presence: true
  validates :region, presence: true


  #Solo se usa para armar lista de beauty tree
  ##INICIO
  def self.beauty_tree_selector(checkeds=[])
    tree = []
    Cuenca.where("LENGTH(codigo_cuenca) = 3").order(id: :asc).each do |cuenca|
      children = cuenca.children(checkeds, 4)
      children_checked = children.select{|child| child[:status] == 'checked'}.size
      children_unchecked = children.select{|child| child[:status] == 'unchecked'}.size
      children_indeterminate = children.select{|child| child[:status] == 'indeterminate'}.size
      status = "unchecked"
      if children.size > 0
        status = 'checked' if children.size == children_checked
        status = "indeterminate" if children_indeterminate > 0 || (children_unchecked > 0 && children_unchecked != children.size)
      else
        status = "checked" if checkeds.include?(cuenca.id)
      end
      tree << {id: cuenca.id, name: "#{cuenca.codigo_cuenca} - #{cuenca.nombre_cuenca}", status: status, children: children}
    end
    tree
  end

  def children(checkeds=[], nivel)
    tree = []
    Cuenca.where("codigo_cuenca LIKE '#{self.codigo_cuenca}%' AND LENGTH(codigo_cuenca) = #{nivel}").order(id: :asc).each do |cuenca|
      children = cuenca.children(checkeds, nivel+1)
      children_checked = children.select{|child| child[:status] == 'checked'}.size
      children_unchecked = children.select{|child| child[:status] == 'unchecked'}.size
      children_indeterminate = children.select{|child| child[:status] == 'indeterminate'}.size
      status = "unchecked"
      if children.size > 0
        status = 'checked' if children.size == children_checked
        status = "indeterminate" if children_indeterminate > 0 || (children_unchecked > 0 && children_unchecked != children.size)
      else
        status = "checked" if checkeds.include?(cuenca.id)
      end
      tree << {id: cuenca.id, name: "#{cuenca.codigo_cuenca} - #{cuenca.nombre_cuenca}", status: status, children: children}
    end
    tree
  end



  def self.beauty_tree_selector_v2(checkeds=[])
    tree = {}
    min_length = 3
    cuencas = Cuenca.where("LENGTH(codigo_cuenca) >= ?", min_length).order("LENGTH(codigo_cuenca) asc, codigo_cuenca asc").all
    cuencas.each do |cuenca|
      cuenca_length = cuenca.codigo_cuenca.length
      if cuenca_length == min_length
        tree[cuenca.codigo_cuenca] = {id: cuenca.id, name: "#{cuenca.codigo_cuenca} - #{cuenca.nombre_cuenca}", status: nil, children: {}}
      else
        padre = cuenca.codigo_cuenca.chop
        tree[padre][:children][cuenca.codigo_cuenca] = {id: cuenca.id, name: "#{cuenca.codigo_cuenca} - #{cuenca.nombre_cuenca}", status: nil, children: {}}
      end
    end

    tree = self.child_tree(tree, checkeds)

    tree
  end

  def self.child_tree(data, checkeds=[])
    data.values.map{|cuenca|
      children = self.child_tree(cuenca[:children], checkeds)
      status = "unchecked"
      if children.size > 0
        children_checked = children.select{|child| child[:status] == 'checked'}.size
        children_unchecked = children.select{|child| child[:status] == 'unchecked'}.size
        children_indeterminate = children.select{|child| child[:status] == 'indeterminate'}.size

        status = 'checked' if children.size == children_checked
        status = "indeterminate" if children_indeterminate > 0 || (children_unchecked > 0 && children_unchecked != children.size)
      else
        status = "checked" if checkeds.include?(cuenca[:id])
      end
      cuenca[:status] = status
      cuenca[:children] = children

      cuenca
    }
  end
  ##FIN
end
