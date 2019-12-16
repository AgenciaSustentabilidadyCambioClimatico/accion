puts "Cargando CIIUV4... DZC"

#Primero seteo todo lo v4 a null
#ActividadEconomica.update_all(codigo_ciiuv4: nil, descripcion_ciiuv4: nil)


act = {
  codigo_ciiuv2: '01',
  codigo_ciiuv4: '01',
  descripcion_ciiuv4: 'Agricultura, ganadería, caza y actividades de servicios conexas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011',
  codigo_ciiuv4: '011',
  descripcion_ciiuv4: 'Cultivo de plantas no perennes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011111',
  codigo_ciiuv4: '011101',
  descripcion_ciiuv4: 'Cultivo de trigo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011112',
  codigo_ciiuv4: '011102',
  descripcion_ciiuv4: 'Cultivo de maíz'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011113',
  codigo_ciiuv4: '011103',
  descripcion_ciiuv4: 'Cultivo de avena'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011115',
  codigo_ciiuv4: '011104',
  descripcion_ciiuv4: 'Cultivo de cebada'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011119',
  codigo_ciiuv4: '011105',
  descripcion_ciiuv4: 'Cultivo de otros cereales (excepto trigo, maíz, avena y cebada)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011131',
  codigo_ciiuv4: '011106',
  descripcion_ciiuv4: 'Cultivo de porotos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011132',
  codigo_ciiuv4: '011107',
  descripcion_ciiuv4: 'Cultivo de lupino'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011139',
  codigo_ciiuv4: '011108',
  descripcion_ciiuv4: 'Cultivo de otras legumbres (excepto porotos y lupino)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011151',
  codigo_ciiuv4: '011109',
  descripcion_ciiuv4: 'Cultivo de semillas de raps'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011152',
  codigo_ciiuv4: '011110',
  descripcion_ciiuv4: 'Cultivo de semillas de maravilla (girasol)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011159',
  codigo_ciiuv4: '011111',
  descripcion_ciiuv4: 'Cultivo de semillas de cereales, legumbres y oleaginosas (excepto semillas de raps y maravilla)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011114',
  codigo_ciiuv4: '011200',
  descripcion_ciiuv4: 'Cultivo de arroz'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011141',
  codigo_ciiuv4: '011301',
  descripcion_ciiuv4: 'Cultivo de papas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011142',
  codigo_ciiuv4: '011302',
  descripcion_ciiuv4: 'Cultivo de camotes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011149',
  codigo_ciiuv4: '011303',
  descripcion_ciiuv4: 'Cultivo de otros tubérculos (excepto papas y camotes)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011191',
  codigo_ciiuv4: '011304',
  descripcion_ciiuv4: 'Cultivo de remolacha azucarera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011230',
  codigo_ciiuv4: '011305',
  descripcion_ciiuv4: 'Cultivo de semillas de hortalizas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011211',
  codigo_ciiuv4: '011306',
  descripcion_ciiuv4: 'Cultivo de hortalizas y melones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011199',
  codigo_ciiuv4: '011400',
  descripcion_ciiuv4: 'Cultivo de caña de azúcar'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011192',
  codigo_ciiuv4: '011500',
  descripcion_ciiuv4: 'Cultivo de tabaco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011193',
  codigo_ciiuv4: '011600',
  descripcion_ciiuv4: 'Cultivo de plantas de fibra'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011220',
  codigo_ciiuv4: '011901',
  descripcion_ciiuv4: 'Cultivo de flores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011121',
  codigo_ciiuv4: '011902',
  descripcion_ciiuv4: 'Cultivos forrajeros en praderas mejoradas o sembradas; cultivos suplementarios forrajeros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011230',
  codigo_ciiuv4: '011903',
  descripcion_ciiuv4: 'Cultivos de semillas de flores; cultivo de semillas de plantas forrajeras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012',
  codigo_ciiuv4: '012',
  descripcion_ciiuv4: 'Cultivo de plantas perennes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011311',
  codigo_ciiuv4: '012111',
  descripcion_ciiuv4: 'Cultivo de uva destinada a la producción de pisco y aguardiente'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011312',
  codigo_ciiuv4: '012112',
  descripcion_ciiuv4: 'Cultivo de uva destinada a la producción de vino'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011313',
  codigo_ciiuv4: '012120',
  descripcion_ciiuv4: 'Cultivo de uva para mesa'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011321',
  codigo_ciiuv4: '012200',
  descripcion_ciiuv4: 'Cultivo de frutas tropicales y subtropicales (incluye el cultivo de paltas)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011321',
  codigo_ciiuv4: '012300',
  descripcion_ciiuv4: 'Cultivo de cítricos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011321',
  codigo_ciiuv4: '012400',
  descripcion_ciiuv4: 'Cultivo de frutas de pepita y de hueso'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011230',
  codigo_ciiuv4: '012501',
  descripcion_ciiuv4: 'Cultivo de semillas de frutas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011321',
  codigo_ciiuv4: '012502',
  descripcion_ciiuv4: 'Cultivo de otros frutos y nueces de árboles y arbustos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011321',
  codigo_ciiuv4: '012600',
  descripcion_ciiuv4: 'Cultivo de frutos oleaginosos (incluye el cultivo de aceitunas)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011330',
  codigo_ciiuv4: '012700',
  descripcion_ciiuv4: 'Cultivo de plantas con las que se preparan bebidas (incluye el cultivo de café, té y mate)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011340',
  codigo_ciiuv4: '012801',
  descripcion_ciiuv4: 'Cultivo de especias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011194',
  codigo_ciiuv4: '012802',
  descripcion_ciiuv4: 'Cultivo de plantas aromáticas, medicinales y farmacéuticas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011193',
  codigo_ciiuv4: '012900',
  descripcion_ciiuv4: 'Cultivo de otras plantas perennes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '013',
  codigo_ciiuv4: '013',
  descripcion_ciiuv4: 'Propagación de plantas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011220',
  codigo_ciiuv4: '013000',
  descripcion_ciiuv4: 'Cultivo de plantas vivas incluida la producción en viveros (excepto viveros forestales)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '014',
  codigo_ciiuv4: '014',
  descripcion_ciiuv4: 'Ganadería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012111',
  codigo_ciiuv4: '014101',
  descripcion_ciiuv4: 'Cría de ganado bovino para la producción lechera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012112',
  codigo_ciiuv4: '014102',
  descripcion_ciiuv4: 'Cría de ganado bovino para la producción de carne o como ganado reproductor'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012130',
  codigo_ciiuv4: '014200',
  descripcion_ciiuv4: 'Cría de caballos y otros equinos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012290',
  codigo_ciiuv4: '014300',
  descripcion_ciiuv4: 'Cría de llamas, alpacas, vicuñas, guanacos y otros camélidos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012120',
  codigo_ciiuv4: '014410',
  descripcion_ciiuv4: 'Cría de ovejas (ovinos)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012290',
  codigo_ciiuv4: '014420',
  descripcion_ciiuv4: 'Cría de cabras (caprinos)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012130',
  codigo_ciiuv4: '014500',
  descripcion_ciiuv4: 'Cría de cerdos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012221',
  codigo_ciiuv4: '014601',
  descripcion_ciiuv4: 'Cría de aves de corral para la producción de carne'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012222',
  codigo_ciiuv4: '014602',
  descripcion_ciiuv4: 'Cría de aves de corral para la producción de huevos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012240',
  codigo_ciiuv4: '014901',
  descripcion_ciiuv4: 'Apicultura'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012223',
  codigo_ciiuv4: '014909',
  descripcion_ciiuv4: 'Cría de otros animales n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '015',
  codigo_ciiuv4: '015',
  descripcion_ciiuv4: 'Cultivo de productos agrícolas en combinación con la cría de animales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '013000',
  codigo_ciiuv4: '015000',
  descripcion_ciiuv4: 'Cultivo de productos agrícolas en combinación con la cría de animales (explotación mixta)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '016',
  codigo_ciiuv4: '016',
  descripcion_ciiuv4: 'Actividades de apoyo a la agricultura y la ganadería y actividades poscosecha'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '014013',
  codigo_ciiuv4: '016100',
  descripcion_ciiuv4: 'Actividades de apoyo a la agricultura'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '014022',
  codigo_ciiuv4: '016200',
  descripcion_ciiuv4: 'Actividades de apoyo a la ganadería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011192',
  codigo_ciiuv4: '016300',
  descripcion_ciiuv4: 'Actividades poscosecha'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '014012',
  codigo_ciiuv4: '016400',
  descripcion_ciiuv4: 'Tratamiento de semillas para propagación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '017',
  codigo_ciiuv4: '017',
  descripcion_ciiuv4: 'Caza ordinaria y mediante trampas y actividades de servicios conexas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '015010',
  codigo_ciiuv4: '017000',
  descripcion_ciiuv4: 'Caza ordinaria y mediante trampas y actividades de servicios conexas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '02',
  codigo_ciiuv4: '02',
  descripcion_ciiuv4: 'Silvicultura y extracción de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '021',
  codigo_ciiuv4: '021',
  descripcion_ciiuv4: 'Silvicultura y otras actividades forestales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '020030',
  codigo_ciiuv4: '021001',
  descripcion_ciiuv4: 'Explotación de viveros forestales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '020010',
  codigo_ciiuv4: '021002',
  descripcion_ciiuv4: 'Silvicultura y otras actividades forestales (excepto explotación de viveros forestales)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '022',
  codigo_ciiuv4: '022',
  descripcion_ciiuv4: 'Extracción de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '020010',
  codigo_ciiuv4: '022000',
  descripcion_ciiuv4: 'Extracción de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '023',
  codigo_ciiuv4: '023',
  descripcion_ciiuv4: 'Recolección de productos forestales distintos de la madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '020020',
  codigo_ciiuv4: '023000',
  descripcion_ciiuv4: 'Recolección de productos forestales distintos de la madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '024',
  codigo_ciiuv4: '024',
  descripcion_ciiuv4: 'Servicios de apoyo a la silvicultura'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '020041',
  codigo_ciiuv4: '024001',
  descripcion_ciiuv4: 'Servicios de forestación a cambio de una retribución o por contrata'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '020042',
  codigo_ciiuv4: '024002',
  descripcion_ciiuv4: 'Servicios de corta de madera a cambio de una retribución o por contrata'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '020043',
  codigo_ciiuv4: '024003',
  descripcion_ciiuv4: 'Servicios de extinción y prevención de incendios forestales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '020049',
  codigo_ciiuv4: '024009',
  descripcion_ciiuv4: 'Otros servicios de apoyo a la silvicultura n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '03',
  codigo_ciiuv4: '03',
  descripcion_ciiuv4: 'Pesca y acuicultura'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '031',
  codigo_ciiuv4: '031',
  descripcion_ciiuv4: 'Pesca'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '052010',
  codigo_ciiuv4: '031110',
  descripcion_ciiuv4: 'Pesca marítima industrial, excepto de barcos factoría'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '052030',
  codigo_ciiuv4: '031120',
  descripcion_ciiuv4: 'Pesca marítima artesanal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '052040',
  codigo_ciiuv4: '031130',
  descripcion_ciiuv4: 'Recolección y extracción de productos marinos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '052050',
  codigo_ciiuv4: '031140',
  descripcion_ciiuv4: 'Servicios relacionados con la pesca marítima'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '052050',
  codigo_ciiuv4: '031200',
  descripcion_ciiuv4: 'Pesca de agua dulce'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '032',
  codigo_ciiuv4: '032',
  descripcion_ciiuv4: 'Acuicultura'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '052010',
  codigo_ciiuv4: '032110',
  descripcion_ciiuv4: 'Cultivo y crianza de peces marinos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '051030',
  codigo_ciiuv4: '032120',
  descripcion_ciiuv4: 'Cultivo, reproducción y manejo de algas marinas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '051040',
  codigo_ciiuv4: '032130',
  descripcion_ciiuv4: 'Reproducción y cría de moluscos, crustáceos y gusanos marinos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '051090',
  codigo_ciiuv4: '032140',
  descripcion_ciiuv4: 'Servicios relacionados con la acuicultura marina'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '012250',
  codigo_ciiuv4: '032200',
  descripcion_ciiuv4: 'Acuicultura de agua dulce'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '04',
  codigo_ciiuv4: '04',
  descripcion_ciiuv4: 'Extracción y procesamiento de cobre'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '040',
  codigo_ciiuv4: '040',
  descripcion_ciiuv4: 'Extracción y procesamiento de cobre'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '133000',
  codigo_ciiuv4: '040000',
  descripcion_ciiuv4: 'Extracción y procesamiento de cobre'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '05',
  codigo_ciiuv4: '05',
  descripcion_ciiuv4: 'Extracción de carbón de piedra y lignito'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '051',
  codigo_ciiuv4: '051',
  descripcion_ciiuv4: 'Extracción de carbón de piedra'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '100000',
  codigo_ciiuv4: '051000',
  descripcion_ciiuv4: 'Extracción de carbón de piedra'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '052',
  codigo_ciiuv4: '052',
  descripcion_ciiuv4: 'Extracción de lignito'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '100000',
  codigo_ciiuv4: '052000',
  descripcion_ciiuv4: 'Extracción de lignito'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '06',
  codigo_ciiuv4: '06',
  descripcion_ciiuv4: 'Extracción de petróleo crudo y gas natural'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '061',
  codigo_ciiuv4: '061',
  descripcion_ciiuv4: 'Extracción de petróleo crudo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '111000',
  codigo_ciiuv4: '061000',
  descripcion_ciiuv4: 'Extracción de petróleo crudo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '062',
  codigo_ciiuv4: '062',
  descripcion_ciiuv4: 'Extracción de gas natural'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '111000',
  codigo_ciiuv4: '062000',
  descripcion_ciiuv4: 'Extracción de gas natural'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '07',
  codigo_ciiuv4: '07',
  descripcion_ciiuv4: 'Extracción de minerales metalíferos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '071',
  codigo_ciiuv4: '071',
  descripcion_ciiuv4: 'Extracción de minerales de hierro'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '131000',
  codigo_ciiuv4: '071000',
  descripcion_ciiuv4: 'Extracción de minerales de hierro'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '072',
  codigo_ciiuv4: '072',
  descripcion_ciiuv4: 'Extracción de minerales metalíferos no ferrosos, excepto cobre'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '120000',
  codigo_ciiuv4: '072100',
  descripcion_ciiuv4: 'Extracción de minerales de uranio y torio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '132010',
  codigo_ciiuv4: '072910',
  descripcion_ciiuv4: 'Extracción de oro y plata'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '132020',
  codigo_ciiuv4: '072991',
  descripcion_ciiuv4: 'Extracción de zinc y plomo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '132030',
  codigo_ciiuv4: '072992',
  descripcion_ciiuv4: 'Extracción de manganeso'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '132090',
  codigo_ciiuv4: '072999',
  descripcion_ciiuv4: 'Extracción de otros minerales metalíferos no ferrosos n.c.p. (excepto zinc, plomo y manganeso)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '08',
  codigo_ciiuv4: '08',
  descripcion_ciiuv4: 'Explotación de otras minas y canteras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '081',
  codigo_ciiuv4: '081',
  descripcion_ciiuv4: 'Extracción de piedra, arena y arcilla'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '141000',
  codigo_ciiuv4: '081000',
  descripcion_ciiuv4: 'Extracción de piedra, arena y arcilla'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '089',
  codigo_ciiuv4: '089',
  descripcion_ciiuv4: 'Explotación de minas y canteras n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '142300',
  codigo_ciiuv4: '089110',
  descripcion_ciiuv4: 'Extracción y procesamiento de litio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '142100',
  codigo_ciiuv4: '089190',
  descripcion_ciiuv4: 'Extracción de minerales para la fabricación de abonos y productos químicos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '100000',
  codigo_ciiuv4: '089200',
  descripcion_ciiuv4: 'Extracción de turba'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '142200',
  codigo_ciiuv4: '089300',
  descripcion_ciiuv4: 'Extracción de sal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '142900',
  codigo_ciiuv4: '089900',
  descripcion_ciiuv4: 'Explotación de otras minas y canteras n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '09',
  codigo_ciiuv4: '09',
  descripcion_ciiuv4: 'Actividades de servicios de apoyo para la explotación de minas y canteras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '091',
  codigo_ciiuv4: '091',
  descripcion_ciiuv4: 'Actividades de apoyo para la extracción de petróleo y gas natural'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '111000',
  codigo_ciiuv4: '091001',
  descripcion_ciiuv4: 'Actividades de apoyo para la extracción de petróleo y gas natural prestados por empresas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '091002',
  descripcion_ciiuv4: 'Actividades de apoyo para la extracción de petróleo y gas natural prestados por profesionales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '099',
  codigo_ciiuv4: '099',
  descripcion_ciiuv4: 'Actividades de apoyo para la explotación de otras minas y canteras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '100000',
  codigo_ciiuv4: '099001',
  descripcion_ciiuv4: 'Actividades de apoyo para la explotación de otras minas y canteras prestados por empresas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '099002',
  descripcion_ciiuv4: 'Actividades de apoyo para la explotación de otras minas y canteras prestados por profesionales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '10',
  codigo_ciiuv4: '10',
  descripcion_ciiuv4: 'Elaboración de productos alimenticios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '101',
  codigo_ciiuv4: '101',
  descripcion_ciiuv4: 'Elaboración y conservación de carne'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151110',
  codigo_ciiuv4: '101011',
  descripcion_ciiuv4: 'Explotación de mataderos de bovinos, ovinos, equinos, caprinos, porcinos y camélidos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151130',
  codigo_ciiuv4: '101019',
  descripcion_ciiuv4: 'Explotación de mataderos de aves y de otros tipos de animales n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151140',
  codigo_ciiuv4: '101020',
  descripcion_ciiuv4: 'Elaboración y conservación de carne y productos cárnicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '102',
  codigo_ciiuv4: '102',
  descripcion_ciiuv4: 'Elaboración y conservación de pescado, crustáceos y moluscos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151210',
  codigo_ciiuv4: '102010',
  descripcion_ciiuv4: 'Producción de harina de pescado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151221',
  codigo_ciiuv4: '102020',
  descripcion_ciiuv4: 'Elaboración y conservación de salmónidos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151221',
  codigo_ciiuv4: '102030',
  descripcion_ciiuv4: 'Elaboración y conservación de otros pescados, en plantas en tierra (excepto barcos factoría)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151221',
  codigo_ciiuv4: '102040',
  descripcion_ciiuv4: 'Elaboración y conservación de crustáceos, moluscos y otros productos acuáticos, en plantas en tierra'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '052020',
  codigo_ciiuv4: '102050',
  descripcion_ciiuv4: 'Actividades de elaboración y conservación de pescado, realizadas en barcos factoría'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151230',
  codigo_ciiuv4: '102060',
  descripcion_ciiuv4: 'Elaboración y procesamiento de algas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '103',
  codigo_ciiuv4: '103',
  descripcion_ciiuv4: 'Elaboración y conservación de frutas, legumbres y hortalizas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151300',
  codigo_ciiuv4: '103000',
  descripcion_ciiuv4: 'Elaboración y conservación de frutas, legumbres y hortalizas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '104',
  codigo_ciiuv4: '104',
  descripcion_ciiuv4: 'Elaboración de aceites y grasas de origen vegetal y animal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151410',
  codigo_ciiuv4: '104000',
  descripcion_ciiuv4: 'Elaboración de aceites y grasas de origen vegetal y animal (excepto elaboración de mantequilla)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '105',
  codigo_ciiuv4: '105',
  descripcion_ciiuv4: 'Elaboración de productos lácteos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '152010',
  codigo_ciiuv4: '105000',
  descripcion_ciiuv4: 'Elaboración de productos lácteos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '106',
  codigo_ciiuv4: '106',
  descripcion_ciiuv4: 'Elaboración de productos de molinería, almidones y productos derivados del almidón'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '153110',
  codigo_ciiuv4: '106101',
  descripcion_ciiuv4: 'Molienda de trigo: producción de harina, sémola y gránulos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '153120',
  codigo_ciiuv4: '106102',
  descripcion_ciiuv4: 'Molienda de arroz; producción de harina de arroz'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '153190',
  codigo_ciiuv4: '106109',
  descripcion_ciiuv4: 'Elaboración de otros productos de molinería n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '153210',
  codigo_ciiuv4: '106200',
  descripcion_ciiuv4: 'Elaboración de almidones y productos derivados del almidón'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '107',
  codigo_ciiuv4: '107',
  descripcion_ciiuv4: 'Elaboración de otros productos alimenticios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154110',
  codigo_ciiuv4: '107100',
  descripcion_ciiuv4: 'Elaboración de productos de panadería y pastelería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154200',
  codigo_ciiuv4: '107200',
  descripcion_ciiuv4: 'Elaboración de azúcar'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154310',
  codigo_ciiuv4: '107300',
  descripcion_ciiuv4: 'Elaboración de cacao, chocolate y de productos de confitería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154400',
  codigo_ciiuv4: '107400',
  descripcion_ciiuv4: 'Elaboración de macarrones, fideos, alcuzcuz y productos farináceos similares'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154400',
  codigo_ciiuv4: '107500',
  descripcion_ciiuv4: 'Elaboración de comidas y platos preparados envasados, rotulados y con información nutricional'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154910',
  codigo_ciiuv4: '107901',
  descripcion_ciiuv4: 'Elaboración de té, café, mate e infusiones de hierbas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154920',
  codigo_ciiuv4: '107902',
  descripcion_ciiuv4: 'Elaboración de levaduras naturales o artificiales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154930',
  codigo_ciiuv4: '107903',
  descripcion_ciiuv4: 'Elaboración de vinagres, mostazas, mayonesas y condimentos en general'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '154990',
  codigo_ciiuv4: '107909',
  descripcion_ciiuv4: 'Elaboración de otros productos alimenticios n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '108',
  codigo_ciiuv4: '108',
  descripcion_ciiuv4: 'Elaboración de piensos preparados para animales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '153300',
  codigo_ciiuv4: '108000',
  descripcion_ciiuv4: 'Elaboración de piensos preparados para animales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '11',
  codigo_ciiuv4: '11',
  descripcion_ciiuv4: 'Elaboración de bebidas alcohólicas y no alcohólicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '110',
  codigo_ciiuv4: '110',
  descripcion_ciiuv4: 'Elaboración de bebidas alcohólicas y no alcohólicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '155110',
  codigo_ciiuv4: '110110',
  descripcion_ciiuv4: 'Elaboración de pisco (industrias pisqueras)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '155120',
  codigo_ciiuv4: '110120',
  descripcion_ciiuv4: 'Destilación, rectificación y mezclas de bebidas alcohólicas; excepto pisco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '011312',
  codigo_ciiuv4: '110200',
  descripcion_ciiuv4: 'Elaboración de vinos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '155300',
  codigo_ciiuv4: '110300',
  descripcion_ciiuv4: 'Elaboración de bebidas malteadas y de malta'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '155410',
  codigo_ciiuv4: '110401',
  descripcion_ciiuv4: 'Elaboración de bebidas no alcohólicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '155420',
  codigo_ciiuv4: '110402',
  descripcion_ciiuv4: 'Producción de aguas minerales y otras aguas embotelladas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '12',
  codigo_ciiuv4: '12',
  descripcion_ciiuv4: 'Elaboración de productos de tabaco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '120',
  codigo_ciiuv4: '120',
  descripcion_ciiuv4: 'Elaboración de productos de tabaco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '160010',
  codigo_ciiuv4: '120001',
  descripcion_ciiuv4: 'Elaboración de cigarros y cigarrillos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '160090',
  codigo_ciiuv4: '120009',
  descripcion_ciiuv4: 'Elaboración de otros productos de tabaco n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '13',
  codigo_ciiuv4: '13',
  descripcion_ciiuv4: 'Fabricación de productos textiles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '131',
  codigo_ciiuv4: '131',
  descripcion_ciiuv4: 'Hilatura, tejedura y acabado de productos textiles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '171100',
  codigo_ciiuv4: '131100',
  descripcion_ciiuv4: 'Preparación e hilatura de fibras textiles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '171100',
  codigo_ciiuv4: '131200',
  descripcion_ciiuv4: 'Tejedura de productos textiles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '171200',
  codigo_ciiuv4: '131300',
  descripcion_ciiuv4: 'Acabado de productos textiles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '139',
  codigo_ciiuv4: '139',
  descripcion_ciiuv4: 'Fabricación de otros productos textiles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '173000',
  codigo_ciiuv4: '139100',
  descripcion_ciiuv4: 'Fabricación de tejidos de punto y ganchillo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '172100',
  codigo_ciiuv4: '139200',
  descripcion_ciiuv4: 'Fabricación de artículos confeccionados de materiales textiles, excepto prendas de vestir'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '172200',
  codigo_ciiuv4: '139300',
  descripcion_ciiuv4: 'Fabricación de tapices y alfombras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '172300',
  codigo_ciiuv4: '139400',
  descripcion_ciiuv4: 'Fabricación de cuerdas, cordeles, bramantes y redes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '172910',
  codigo_ciiuv4: '139900',
  descripcion_ciiuv4: 'Fabricación de otros productos textiles n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '14',
  codigo_ciiuv4: '14',
  descripcion_ciiuv4: 'Fabricación de prendas de vestir'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '141',
  codigo_ciiuv4: '141',
  descripcion_ciiuv4: 'Fabricación de prendas de vestir, excepto prendas de piel'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '181010',
  codigo_ciiuv4: '141001',
  descripcion_ciiuv4: 'Fabricación de prendas de vestir de materiales textiles y similares'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '181020',
  codigo_ciiuv4: '141002',
  descripcion_ciiuv4: 'Fabricación de prendas de vestir de cuero natural o artificial'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '181030',
  codigo_ciiuv4: '141003',
  descripcion_ciiuv4: 'Fabricación de accesorios de vestir'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '181040',
  codigo_ciiuv4: '141004',
  descripcion_ciiuv4: 'Fabricación de ropa de trabajo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '142',
  codigo_ciiuv4: '142',
  descripcion_ciiuv4: 'Fabricación de artículos de piel'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '182000',
  codigo_ciiuv4: '142000',
  descripcion_ciiuv4: 'Fabricación de artículos de piel'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '143',
  codigo_ciiuv4: '143',
  descripcion_ciiuv4: 'Fabricación de artículos de punto y ganchillo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '173000',
  codigo_ciiuv4: '143000',
  descripcion_ciiuv4: 'Fabricación de artículos de punto y ganchillo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '15',
  codigo_ciiuv4: '15',
  descripcion_ciiuv4: 'Fabricación de productos de cuero y productos conexos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '151',
  codigo_ciiuv4: '151',
  descripcion_ciiuv4: 'Curtido y adobo de cueros; fabricación productos de cuero; adobo y teñido de pieles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '182000',
  codigo_ciiuv4: '151100',
  descripcion_ciiuv4: 'Curtido y adobo de cueros; adobo y teñido de pieles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '191200',
  codigo_ciiuv4: '151200',
  descripcion_ciiuv4: 'Fabricación de maletas, bolsos y artículos similares, artículos de talabartería y guarnicionería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '152',
  codigo_ciiuv4: '152',
  descripcion_ciiuv4: 'Fabricación de calzado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '192000',
  codigo_ciiuv4: '152000',
  descripcion_ciiuv4: 'Fabricación de calzado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '16',
  codigo_ciiuv4: '16',
  descripcion_ciiuv4: 'Producción de madera y fabricación de productos de madera y corcho, excepto muebles; fabricación de artículos de paja y de materiales trenzables'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '161',
  codigo_ciiuv4: '161',
  descripcion_ciiuv4: 'Aserrado y acepilladura de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '201000',
  codigo_ciiuv4: '161000',
  descripcion_ciiuv4: 'Aserrado y acepilladura de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '162',
  codigo_ciiuv4: '162',
  descripcion_ciiuv4: 'Fabricación de productos de madera, corcho, paja y materiales trenzables'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '202100',
  codigo_ciiuv4: '162100',
  descripcion_ciiuv4: 'Fabricación de hojas de madera para enchapado y tableros a base de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '202200',
  codigo_ciiuv4: '162200',
  descripcion_ciiuv4: 'Fabricación de partes y piezas de carpintería para edificios y construcciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '202300',
  codigo_ciiuv4: '162300',
  descripcion_ciiuv4: 'Fabricación de recipientes de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '202900',
  codigo_ciiuv4: '162900',
  descripcion_ciiuv4: 'Fabricación de otros productos de madera, de artículos de corcho, paja y materiales trenzables'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '17',
  codigo_ciiuv4: '17',
  descripcion_ciiuv4: 'Fabricación de papel y de productos de papel'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '170',
  codigo_ciiuv4: '170',
  descripcion_ciiuv4: 'Fabricación de papel y de productos de papel'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '210110',
  codigo_ciiuv4: '170110',
  descripcion_ciiuv4: 'Fabricación de celulosa y otras pastas de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '210121',
  codigo_ciiuv4: '170190',
  descripcion_ciiuv4: 'Fabricación de papel y cartón para su posterior uso industrial n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '210200',
  codigo_ciiuv4: '170200',
  descripcion_ciiuv4: 'Fabricación de papel y cartón ondulado y de envases de papel y cartón'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '172990',
  codigo_ciiuv4: '170900',
  descripcion_ciiuv4: 'Fabricación de otros artículos de papel y cartón'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '18',
  codigo_ciiuv4: '18',
  descripcion_ciiuv4: 'Impresión y reproducción de grabaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '181',
  codigo_ciiuv4: '181',
  descripcion_ciiuv4: 'Impresión y actividades de servicios relacionadas con la impresión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '222101',
  codigo_ciiuv4: '181101',
  descripcion_ciiuv4: 'Impresión de libros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '222109',
  codigo_ciiuv4: '181109',
  descripcion_ciiuv4: 'Otras actividades de impresión n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '222200',
  codigo_ciiuv4: '181200',
  descripcion_ciiuv4: 'Actividades de servicios relacionadas con la impresión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '182',
  codigo_ciiuv4: '182',
  descripcion_ciiuv4: 'Reproducción de grabaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '223000',
  codigo_ciiuv4: '182000',
  descripcion_ciiuv4: 'Reproducción de grabaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '19',
  codigo_ciiuv4: '19',
  descripcion_ciiuv4: 'Fabricación de coque y productos de la refinación del petróleo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '191',
  codigo_ciiuv4: '191',
  descripcion_ciiuv4: 'Fabricación de productos de hornos de coque'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '231000',
  codigo_ciiuv4: '191000',
  descripcion_ciiuv4: 'Fabricación de productos de hornos de coque'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '192',
  codigo_ciiuv4: '192',
  descripcion_ciiuv4: 'Fabricación de productos de la refinación del petróleo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '232000',
  codigo_ciiuv4: '192000',
  descripcion_ciiuv4: 'Fabricación de productos de la refinación del petróleo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '20',
  codigo_ciiuv4: '20',
  descripcion_ciiuv4: 'Fabricación de sustancias y productos químicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '201',
  codigo_ciiuv4: '201',
  descripcion_ciiuv4: 'Fabricación sustancias químicas básicas, abonos y compuestos de nitrógeno, plásticos y caucho sint.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '241110',
  codigo_ciiuv4: '201101',
  descripcion_ciiuv4: 'Fabricación de carbón vegetal (excepto activado); fabricación de briquetas de carbón vegetal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '233000',
  codigo_ciiuv4: '201109',
  descripcion_ciiuv4: 'Fabricación de otras sustancias químicas básicas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '241200',
  codigo_ciiuv4: '201200',
  descripcion_ciiuv4: 'Fabricación de abonos y compuestos de nitrógeno'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '241300',
  codigo_ciiuv4: '201300',
  descripcion_ciiuv4: 'Fabricación de plásticos y caucho sintético en formas primarias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '202',
  codigo_ciiuv4: '202',
  descripcion_ciiuv4: 'Fabricación de otros productos químicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '242100',
  codigo_ciiuv4: '202100',
  descripcion_ciiuv4: 'Fabricación de plaguicidas y otros productos químicos de uso agropecuario'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '242200',
  codigo_ciiuv4: '202200',
  descripcion_ciiuv4: 'Fabricación de pinturas, barnices y productos de revestimiento, tintas de imprenta y masillas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '242400',
  codigo_ciiuv4: '202300',
  descripcion_ciiuv4: 'Fabricación de jabones y detergentes, preparados para limpiar, perfumes y preparados de tocador'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '242910',
  codigo_ciiuv4: '202901',
  descripcion_ciiuv4: 'Fabricación de explosivos y productos pirotécnicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '242990',
  codigo_ciiuv4: '202909',
  descripcion_ciiuv4: 'Fabricación de otros productos químicos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '203',
  codigo_ciiuv4: '203',
  descripcion_ciiuv4: 'Fabricación de fibras artificiales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '243000',
  codigo_ciiuv4: '203000',
  descripcion_ciiuv4: 'Fabricación de fibras artificiales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '21',
  codigo_ciiuv4: '21',
  descripcion_ciiuv4: 'Fabricación de productos farmacéuticos, sustancias químicas medicinales y productos botánicos de uso farmacéutico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '210',
  codigo_ciiuv4: '210',
  descripcion_ciiuv4: 'Fabricación de productos farmacéuticos, sustancias químicas medicinales y productos botánicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '233000',
  codigo_ciiuv4: '210000',
  descripcion_ciiuv4: 'Fabricación de productos farmacéuticos, sustancias químicas medicinales y productos botánicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '22',
  codigo_ciiuv4: '22',
  descripcion_ciiuv4: 'Fabricación de productos de caucho y de plástico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '221',
  codigo_ciiuv4: '221',
  descripcion_ciiuv4: 'Fabricación de productos de caucho'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '251110',
  codigo_ciiuv4: '221100',
  descripcion_ciiuv4: 'Fabricación de cubiertas y cámaras de caucho; recauchutado y renovación de cubiertas de caucho'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '251900',
  codigo_ciiuv4: '221900',
  descripcion_ciiuv4: 'Fabricación de otros productos de caucho'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '222',
  codigo_ciiuv4: '222',
  descripcion_ciiuv4: 'Fabricación de productos de plástico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '251900',
  codigo_ciiuv4: '222000',
  descripcion_ciiuv4: 'Fabricación de productos de plástico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '23',
  codigo_ciiuv4: '23',
  descripcion_ciiuv4: 'Fabricación de otros productos minerales no metálicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '231',
  codigo_ciiuv4: '231',
  descripcion_ciiuv4: 'Fabricación de vidrio y productos de vidrio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '261010',
  codigo_ciiuv4: '231001',
  descripcion_ciiuv4: 'Fabricación de vidrio plano'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '261020',
  codigo_ciiuv4: '231002',
  descripcion_ciiuv4: 'Fabricación de vidrio hueco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '261030',
  codigo_ciiuv4: '231003',
  descripcion_ciiuv4: 'Fabricación de fibras de vidrio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '261090',
  codigo_ciiuv4: '231009',
  descripcion_ciiuv4: 'Fabricación de productos de vidrio n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '239',
  codigo_ciiuv4: '239',
  descripcion_ciiuv4: 'Fabricación de productos minerales no metálicos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '269200',
  codigo_ciiuv4: '239100',
  descripcion_ciiuv4: 'Fabricación de productos refractarios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '269300',
  codigo_ciiuv4: '239200',
  descripcion_ciiuv4: 'Fabricación de materiales de construcción de arcilla'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '269101',
  codigo_ciiuv4: '239300',
  descripcion_ciiuv4: 'Fabricación de otros productos de porcelana y de cerámica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '269400',
  codigo_ciiuv4: '239400',
  descripcion_ciiuv4: 'Fabricación de cemento, cal y yeso'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '269510',
  codigo_ciiuv4: '239500',
  descripcion_ciiuv4: 'Fabricación de artículos de hormigón, cemento y yeso'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '269600',
  codigo_ciiuv4: '239600',
  descripcion_ciiuv4: 'Corte, talla y acabado de la piedra'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '269910',
  codigo_ciiuv4: '239900',
  descripcion_ciiuv4: 'Fabricación de otros productos minerales no metálicos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '24',
  codigo_ciiuv4: '24',
  descripcion_ciiuv4: 'Fabricación de metales comunes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '241',
  codigo_ciiuv4: '241',
  descripcion_ciiuv4: 'Industrias básicas de hierro y acero'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '271000',
  codigo_ciiuv4: '241000',
  descripcion_ciiuv4: 'Industrias básicas de hierro y acero'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '242',
  codigo_ciiuv4: '242',
  descripcion_ciiuv4: 'Fabricación de productos primarios de metales preciosos y otros metales no ferrosos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '272010',
  codigo_ciiuv4: '242001',
  descripcion_ciiuv4: 'Fabricación de productos primarios de cobre'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '272020',
  codigo_ciiuv4: '242002',
  descripcion_ciiuv4: 'Fabricación de productos primarios de aluminio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '272090',
  codigo_ciiuv4: '242009',
  descripcion_ciiuv4: 'Fabricación de productos primarios de metales preciosos y de otros metales no ferrosos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '243',
  codigo_ciiuv4: '243',
  descripcion_ciiuv4: 'Fundición de metales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '273100',
  codigo_ciiuv4: '243100',
  descripcion_ciiuv4: 'Fundición de hierro y acero'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '273200',
  codigo_ciiuv4: '243200',
  descripcion_ciiuv4: 'Fundición de metales no ferrosos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '25',
  codigo_ciiuv4: '25',
  descripcion_ciiuv4: 'Fabricación de productos elaborados de metal, excepto maquinaria y equipo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '251',
  codigo_ciiuv4: '251',
  descripcion_ciiuv4: 'Fabricación de productos metálicos para uso estructural, tanques, depósitos, recipientes de metal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '281100',
  codigo_ciiuv4: '251100',
  descripcion_ciiuv4: 'Fabricación de productos metálicos para uso estructural'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '281211',
  codigo_ciiuv4: '251201',
  descripcion_ciiuv4: 'Fabricación de recipientes de metal para gases comprimidos o licuados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '281219',
  codigo_ciiuv4: '251209',
  descripcion_ciiuv4: 'Fabricación de tanques, depósitos y recipientes de metal n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '281310',
  codigo_ciiuv4: '251300',
  descripcion_ciiuv4: 'Fabricación de generadores de vapor, excepto calderas de agua caliente para calefacción central'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '252',
  codigo_ciiuv4: '252',
  descripcion_ciiuv4: 'Fabricación de armas y municiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '252000',
  descripcion_ciiuv4: 'Fabricación de armas y municiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '259',
  codigo_ciiuv4: '259',
  descripcion_ciiuv4: 'Fabricación de otros productos elaborados de metal; actividades de servicios de trabajo de metales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '289100',
  codigo_ciiuv4: '259100',
  descripcion_ciiuv4: 'Forja, prensado, estampado y laminado de metales; pulvimetalurgia'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '289200',
  codigo_ciiuv4: '259200',
  descripcion_ciiuv4: 'Tratamiento y revestimiento de metales; maquinado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '289310',
  codigo_ciiuv4: '259300',
  descripcion_ciiuv4: 'Fabricación de artículos de cuchillería, herramientas de mano y artículos de ferretería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '289910',
  codigo_ciiuv4: '259900',
  descripcion_ciiuv4: 'Fabricación de otros productos elaborados de metal n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '26',
  codigo_ciiuv4: '26',
  descripcion_ciiuv4: 'Fabricación de productos de informática, de electrónica y de óptica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '261',
  codigo_ciiuv4: '261',
  descripcion_ciiuv4: 'Fabricación de componentes y tableros electrónicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '242990',
  codigo_ciiuv4: '261000',
  descripcion_ciiuv4: 'Fabricación de componentes y tableros electrónicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '262',
  codigo_ciiuv4: '262',
  descripcion_ciiuv4: 'Fabricación de computadores y equipo periférico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '262000',
  descripcion_ciiuv4: 'Fabricación de computadores y equipo periférico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '263',
  codigo_ciiuv4: '263',
  descripcion_ciiuv4: 'Fabricación de equipo de comunicaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '263000',
  descripcion_ciiuv4: 'Fabricación de equipo de comunicaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '264',
  codigo_ciiuv4: '264',
  descripcion_ciiuv4: 'Fabricación de aparatos electrónicos de consumo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '264000',
  descripcion_ciiuv4: 'Fabricación de aparatos electrónicos de consumo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '265',
  codigo_ciiuv4: '265',
  descripcion_ciiuv4: 'Fabricación de equipo de medición, prueba, navegación y control y de relojes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '265100',
  descripcion_ciiuv4: 'Fabricación de equipo de medición, prueba, navegación y control'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '265200',
  descripcion_ciiuv4: 'Fabricación de relojes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '266',
  codigo_ciiuv4: '266',
  descripcion_ciiuv4: 'Fabricación de equipo de irradiación y equipo electrónico de uso médico y terapéutico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '266000',
  descripcion_ciiuv4: 'Fabricación de equipo de irradiación y equipo electrónico de uso médico y terapéutico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '267',
  codigo_ciiuv4: '267',
  descripcion_ciiuv4: 'Fabricación de instrumentos ópticos y equipo fotográfico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '267000',
  descripcion_ciiuv4: 'Fabricación de instrumentos ópticos y equipo fotográfico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '268',
  codigo_ciiuv4: '268',
  descripcion_ciiuv4: 'Fabricación de soportes magnéticos y ópticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '242990',
  codigo_ciiuv4: '268000',
  descripcion_ciiuv4: 'Fabricación de soportes magnéticos y ópticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '27',
  codigo_ciiuv4: '27',
  descripcion_ciiuv4: 'Fabricación de equipo eléctrico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '271',
  codigo_ciiuv4: '271',
  descripcion_ciiuv4: 'Fabricación de motores, generadores y transformadores eléctricos, aparatos de distribución y control'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '311010',
  codigo_ciiuv4: '271000',
  descripcion_ciiuv4: 'Fabricación de motores, generadores y transformadores eléctricos, aparatos de distribución y control'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '272',
  codigo_ciiuv4: '272',
  descripcion_ciiuv4: 'Fabricación de pilas, baterías y acumuladores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '272000',
  descripcion_ciiuv4: 'Fabricación de pilas, baterías y acumuladores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '273',
  codigo_ciiuv4: '273',
  descripcion_ciiuv4: 'Fabricación de cables y dispositivos de cableado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '313000',
  codigo_ciiuv4: '273100',
  descripcion_ciiuv4: 'Fabricación de cables de fibra óptica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '313000',
  codigo_ciiuv4: '273200',
  descripcion_ciiuv4: 'Fabricación de otros hilos y cables eléctricos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '252090',
  codigo_ciiuv4: '273300',
  descripcion_ciiuv4: 'Fabricación de dispositivos de cableado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '274',
  codigo_ciiuv4: '274',
  descripcion_ciiuv4: 'Fabricación de equipo eléctrico de iluminación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '274000',
  descripcion_ciiuv4: 'Fabricación de equipo eléctrico de iluminación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '275',
  codigo_ciiuv4: '275',
  descripcion_ciiuv4: 'Fabricación de aparatos de uso doméstico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '275000',
  descripcion_ciiuv4: 'Fabricación de aparatos de uso doméstico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '279',
  codigo_ciiuv4: '279',
  descripcion_ciiuv4: 'Fabricación de otros tipos de equipo eléctrico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292210',
  codigo_ciiuv4: '279000',
  descripcion_ciiuv4: 'Fabricación de otros tipos de equipo eléctrico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '28',
  codigo_ciiuv4: '28',
  descripcion_ciiuv4: 'Fabricación de maquinaria y equipo n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '281',
  codigo_ciiuv4: '281',
  descripcion_ciiuv4: 'Fabricación de maquinaria de uso general'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '291110',
  codigo_ciiuv4: '281100',
  descripcion_ciiuv4: 'Fabricación de motores y turbinas, excepto para aeronaves, vehículos automotores y motocicletas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '251900',
  codigo_ciiuv4: '281200',
  descripcion_ciiuv4: 'Fabricación de equipo de propulsión de fluidos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '291210',
  codigo_ciiuv4: '281300',
  descripcion_ciiuv4: 'Fabricación de otras bombas, compresores, grifos y válvulas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '291310',
  codigo_ciiuv4: '281400',
  descripcion_ciiuv4: 'Fabricación de cojinetes, engranajes, trenes de engranajes y piezas de transmisión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '291410',
  codigo_ciiuv4: '281500',
  descripcion_ciiuv4: 'Fabricación de hornos, calderas y quemadores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '291510',
  codigo_ciiuv4: '281600',
  descripcion_ciiuv4: 'Fabricación de equipo de elevación y manipulación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '300020',
  codigo_ciiuv4: '281700',
  descripcion_ciiuv4: 'Fabricación de maquinaria y equipo de oficina (excepto computadores y equipo periférico)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292210',
  codigo_ciiuv4: '281800',
  descripcion_ciiuv4: 'Fabricación de herramientas de mano motorizadas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '291910',
  codigo_ciiuv4: '281900',
  descripcion_ciiuv4: 'Fabricación de otros tipos de maquinaria de uso general'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '282',
  codigo_ciiuv4: '282',
  descripcion_ciiuv4: 'Fabricación de maquinaria de uso especial'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292110',
  codigo_ciiuv4: '282100',
  descripcion_ciiuv4: 'Fabricación de maquinaria agropecuaria y forestal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292210',
  codigo_ciiuv4: '282200',
  descripcion_ciiuv4: 'Fabricación de maquinaria para la conformación de metales y de máquinas herramienta'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292310',
  codigo_ciiuv4: '282300',
  descripcion_ciiuv4: 'Fabricación de maquinaria metalúrgica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292411',
  codigo_ciiuv4: '282400',
  descripcion_ciiuv4: 'Fabricación de maquinaria para la explotación de minas y canteras y para obras de construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292510',
  codigo_ciiuv4: '282500',
  descripcion_ciiuv4: 'Fabricación de maquinaria para la elaboración de alimentos, bebidas y tabaco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292610',
  codigo_ciiuv4: '282600',
  descripcion_ciiuv4: 'Fabricación de maquinaria para la elaboración de productos textiles, prendas de vestir y cueros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292910',
  codigo_ciiuv4: '282900',
  descripcion_ciiuv4: 'Fabricación de otros tipos de maquinaria de uso especial'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '29',
  codigo_ciiuv4: '29',
  descripcion_ciiuv4: 'Fabricación de vehículos automotores, remolques y semirremolques'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '291',
  codigo_ciiuv4: '291',
  descripcion_ciiuv4: 'Fabricación de vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '291000',
  descripcion_ciiuv4: 'Fabricación de vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292',
  codigo_ciiuv4: '292',
  descripcion_ciiuv4: 'Fabricación de carrocerías para vehículos automotores; fabricación de remolques y semirremolques'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '292000',
  descripcion_ciiuv4: 'Fabricación de carrocerías para vehículos automotores; fabricación de remolques y semirremolques'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '293',
  codigo_ciiuv4: '293',
  descripcion_ciiuv4: 'Fabricación de partes, piezas y accesorios para vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '293000',
  descripcion_ciiuv4: 'Fabricación de partes, piezas y accesorios para vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '30',
  codigo_ciiuv4: '30',
  descripcion_ciiuv4: 'Fabricación de otros tipos de equipo de transporte'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '301',
  codigo_ciiuv4: '301',
  descripcion_ciiuv4: 'Construcción de buques y otras embarcaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '301100',
  descripcion_ciiuv4: 'Construcción de buques, embarcaciones menores y estructuras flotantes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '301200',
  descripcion_ciiuv4: 'Construcción de embarcaciones de recreo y de deporte'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '302',
  codigo_ciiuv4: '302',
  descripcion_ciiuv4: 'Fabricación de locomotoras y material rodante'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '319010',
  codigo_ciiuv4: '302000',
  descripcion_ciiuv4: 'Fabricación de locomotoras y material rodante'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '303',
  codigo_ciiuv4: '303',
  descripcion_ciiuv4: 'Fabricación de aeronaves, naves espaciales y maquinaria conexa'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '353010',
  codigo_ciiuv4: '303000',
  descripcion_ciiuv4: 'Fabricación de aeronaves, naves espaciales y maquinaria conexa'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '304',
  codigo_ciiuv4: '304',
  descripcion_ciiuv4: 'Fabricación de vehículos militares de combate'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292710',
  codigo_ciiuv4: '304000',
  descripcion_ciiuv4: 'Fabricación de vehículos militares de combate'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '309',
  codigo_ciiuv4: '309',
  descripcion_ciiuv4: 'Fabricación de equipo de transporte n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '359100',
  codigo_ciiuv4: '309100',
  descripcion_ciiuv4: 'Fabricación de motocicletas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '359200',
  codigo_ciiuv4: '309200',
  descripcion_ciiuv4: 'Fabricación de bicicletas y de sillas de ruedas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '359900',
  codigo_ciiuv4: '309900',
  descripcion_ciiuv4: 'Fabricación de otros tipos de equipo de transporte n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '31',
  codigo_ciiuv4: '31',
  descripcion_ciiuv4: 'Fabricación de muebles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '310',
  codigo_ciiuv4: '310',
  descripcion_ciiuv4: 'Fabricación de muebles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '361010',
  codigo_ciiuv4: '310001',
  descripcion_ciiuv4: 'Fabricación de muebles principalmente de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '359900',
  codigo_ciiuv4: '310009',
  descripcion_ciiuv4: 'Fabricación de colchones; fabricación de otros muebles n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '32',
  codigo_ciiuv4: '32',
  descripcion_ciiuv4: 'Otras industrias manufactureras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '321',
  codigo_ciiuv4: '321',
  descripcion_ciiuv4: 'Fabricación de joyas, bisutería y artículos conexos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '369100',
  codigo_ciiuv4: '321100',
  descripcion_ciiuv4: 'Fabricación de joyas y artículos conexos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '369990',
  codigo_ciiuv4: '321200',
  descripcion_ciiuv4: 'Fabricación de bisutería y artículos conexos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '322',
  codigo_ciiuv4: '322',
  descripcion_ciiuv4: 'Fabricación de instrumentos musicales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '369200',
  codigo_ciiuv4: '322000',
  descripcion_ciiuv4: 'Fabricación de instrumentos musicales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '323',
  codigo_ciiuv4: '323',
  descripcion_ciiuv4: 'Fabricación de artículos de deporte'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '369300',
  codigo_ciiuv4: '323000',
  descripcion_ciiuv4: 'Fabricación de artículos de deporte'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '324',
  codigo_ciiuv4: '324',
  descripcion_ciiuv4: 'Fabricación de juegos y juguetes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '369400',
  codigo_ciiuv4: '324000',
  descripcion_ciiuv4: 'Fabricación de juegos y juguetes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '325',
  codigo_ciiuv4: '325',
  descripcion_ciiuv4: 'Fabricación de instrumentos y materiales médicos y odontológicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '331120',
  codigo_ciiuv4: '325001',
  descripcion_ciiuv4: 'Actividades de laboratorios dentales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '331110',
  codigo_ciiuv4: '325009',
  descripcion_ciiuv4: 'Fabricación de instrumentos y materiales médicos, oftalmológicos y odontológicos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '329',
  codigo_ciiuv4: '329',
  descripcion_ciiuv4: 'Otras industrias manufactureras n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '331110',
  codigo_ciiuv4: '329000',
  descripcion_ciiuv4: 'Otras industrias manufactureras n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '33',
  codigo_ciiuv4: '33',
  descripcion_ciiuv4: 'Reparación e instalación de maquinaria y equipo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '331',
  codigo_ciiuv4: '331',
  descripcion_ciiuv4: 'Reparación de productos elaborados de metal, maquinaria y equipo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '342000',
  codigo_ciiuv4: '331100',
  descripcion_ciiuv4: 'Reparación de productos elaborados de metal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '331201',
  descripcion_ciiuv4: 'Reparación de maquinaria agropecuaria y forestal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292380',
  codigo_ciiuv4: '331202',
  descripcion_ciiuv4: 'Reparación de maquinaria metalúrgica, para la minería, extracción de petróleo y para la construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292580',
  codigo_ciiuv4: '331203',
  descripcion_ciiuv4: 'Reparación de maquinaria para la elaboración de alimentos, bebidas y tabaco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292680',
  codigo_ciiuv4: '331204',
  descripcion_ciiuv4: 'Reparación de maquinaria para producir textiles, prendas de vestir, artículos de cuero y calzado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '292980',
  codigo_ciiuv4: '331209',
  descripcion_ciiuv4: 'Reparación de otro tipo de maquinaria y equipos industriales n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '331280',
  codigo_ciiuv4: '331301',
  descripcion_ciiuv4: 'Reparación de equipo de medición, prueba, navegación y control'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '319080',
  codigo_ciiuv4: '331309',
  descripcion_ciiuv4: 'Reparación de otros equipos electrónicos y ópticos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '319080',
  codigo_ciiuv4: '331400',
  descripcion_ciiuv4: 'Reparación de equipo eléctrico (excepto reparación de equipo y enseres domésticos)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '351110',
  codigo_ciiuv4: '331501',
  descripcion_ciiuv4: 'Reparación de buques, embarcaciones menores y estructuras flotantes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '353080',
  codigo_ciiuv4: '331502',
  descripcion_ciiuv4: 'Reparación de aeronaves y naves espaciales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '352000',
  codigo_ciiuv4: '331509',
  descripcion_ciiuv4: 'Reparación de otros equipos de transporte n.c.p., excepto vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '369200',
  codigo_ciiuv4: '331900',
  descripcion_ciiuv4: 'Reparación de otros tipos de equipo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '332',
  codigo_ciiuv4: '332',
  descripcion_ciiuv4: 'Instalación de maquinaria y equipos industriales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '454000',
  codigo_ciiuv4: '332000',
  descripcion_ciiuv4: 'Instalación de maquinaria y equipos industriales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '35',
  codigo_ciiuv4: '35',
  descripcion_ciiuv4: 'Suministro de electricidad, gas, vapor y aire acondicionado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '351',
  codigo_ciiuv4: '351',
  descripcion_ciiuv4: 'Generación, transmisión y distribución de energía eléctrica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '401011',
  codigo_ciiuv4: '351011',
  descripcion_ciiuv4: 'Generación de energía eléctrica en centrales hidroeléctricas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '401012',
  codigo_ciiuv4: '351012',
  descripcion_ciiuv4: 'Generación de energía eléctrica en centrales termoeléctricas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '401019',
  codigo_ciiuv4: '351019',
  descripcion_ciiuv4: 'Generación de energía eléctrica en otras centrales n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '401020',
  codigo_ciiuv4: '351020',
  descripcion_ciiuv4: 'Transmisión de energía eléctrica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '401030',
  codigo_ciiuv4: '351030',
  descripcion_ciiuv4: 'Distribución de energía eléctrica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '352',
  codigo_ciiuv4: '352',
  descripcion_ciiuv4: 'Fabricación de gas; distribución de combustibles gaseosos por tuberías'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '402000',
  codigo_ciiuv4: '352010',
  descripcion_ciiuv4: 'Regasificación de gas natural licuado (gnl)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '402000',
  codigo_ciiuv4: '352020',
  descripcion_ciiuv4: 'Fabricación de gas; distribución de combustibles gaseosos por tubería, excepto regasificación de gnl'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '353',
  codigo_ciiuv4: '353',
  descripcion_ciiuv4: 'Suministro de vapor y de aire acondicionado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '403000',
  codigo_ciiuv4: '353001',
  descripcion_ciiuv4: 'Suministro de vapor y de aire acondicionado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '353002',
  descripcion_ciiuv4: 'Elaboración de hielo (excepto fabricación de hielo seco)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '36',
  codigo_ciiuv4: '36',
  descripcion_ciiuv4: 'Captación, tratamiento y distribución de agua'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '360',
  codigo_ciiuv4: '360',
  descripcion_ciiuv4: 'Captación, tratamiento y distribución de agua'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '410000',
  codigo_ciiuv4: '360000',
  descripcion_ciiuv4: 'Captación, tratamiento y distribución de agua'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '37',
  codigo_ciiuv4: '37',
  descripcion_ciiuv4: 'Evacuación de aguas residuales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '370',
  codigo_ciiuv4: '370',
  descripcion_ciiuv4: 'Evacuación de aguas residuales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '370000',
  descripcion_ciiuv4: 'Evacuación y tratamiento de aguas servidas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '38',
  codigo_ciiuv4: '38',
  descripcion_ciiuv4: 'Recogida, tratamiento y eliminación de desechos; recuperación de mate-riales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '381',
  codigo_ciiuv4: '381',
  descripcion_ciiuv4: 'Recogida de desechos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '381100',
  descripcion_ciiuv4: 'Recogida de desechos no peligrosos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '233000',
  codigo_ciiuv4: '381200',
  descripcion_ciiuv4: 'Recogida de desechos peligrosos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '382',
  codigo_ciiuv4: '382',
  descripcion_ciiuv4: 'Tratamiento y eliminación de desechos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '241200',
  codigo_ciiuv4: '382100',
  descripcion_ciiuv4: 'Tratamiento y eliminación de desechos no peligrosos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '233000',
  codigo_ciiuv4: '382200',
  descripcion_ciiuv4: 'Tratamiento y eliminación de desechos peligrosos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '383',
  codigo_ciiuv4: '383',
  descripcion_ciiuv4: 'Recuperación de materiales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '371000',
  codigo_ciiuv4: '383001',
  descripcion_ciiuv4: 'Recuperación y reciclamiento de desperdicios y desechos metálicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '372010',
  codigo_ciiuv4: '383002',
  descripcion_ciiuv4: 'Recuperación y reciclamiento de papel'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '372020',
  codigo_ciiuv4: '383003',
  descripcion_ciiuv4: 'Recuperación y reciclamiento de vidrio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '372090',
  codigo_ciiuv4: '383009',
  descripcion_ciiuv4: 'Recuperación y reciclamiento de otros desperdicios y desechos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '39',
  codigo_ciiuv4: '39',
  descripcion_ciiuv4: 'Actividades de descontaminación y otros servicios de gestión de dese-chos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '390',
  codigo_ciiuv4: '390',
  descripcion_ciiuv4: 'Actividades de descontaminación y otros servicios de gestión de desechos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '451010',
  codigo_ciiuv4: '390000',
  descripcion_ciiuv4: 'Actividades de descontaminación y otros servicios de gestión de desechos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '41',
  codigo_ciiuv4: '41',
  descripcion_ciiuv4: 'Construcción de edificios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '410',
  codigo_ciiuv4: '410',
  descripcion_ciiuv4: 'Construcción de edificios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '452010',
  codigo_ciiuv4: '410010',
  descripcion_ciiuv4: 'Construcción de edificios para uso residencial'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '452010',
  codigo_ciiuv4: '410020',
  descripcion_ciiuv4: 'Construcción de edificios para uso no residencial'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '42',
  codigo_ciiuv4: '42',
  descripcion_ciiuv4: 'Obras de ingeniería civil'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '421',
  codigo_ciiuv4: '421',
  descripcion_ciiuv4: 'Construcción de carreteras y líneas de ferrocarril'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '452020',
  codigo_ciiuv4: '421000',
  descripcion_ciiuv4: 'Construcción de carreteras y líneas de ferrocarril'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '422',
  codigo_ciiuv4: '422',
  descripcion_ciiuv4: 'Construcción de proyectos de servicio público'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '452020',
  codigo_ciiuv4: '422000',
  descripcion_ciiuv4: 'Construcción de proyectos de servicio público'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '429',
  codigo_ciiuv4: '429',
  descripcion_ciiuv4: 'Construcción de otras obras de ingeniería civil'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '452020',
  codigo_ciiuv4: '429000',
  descripcion_ciiuv4: 'Construcción de otras obras de ingeniería civil'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '43',
  codigo_ciiuv4: '43',
  descripcion_ciiuv4: 'Actividades especializadas de construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '431',
  codigo_ciiuv4: '431',
  descripcion_ciiuv4: 'Demolición y preparación del terreno'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '451020',
  codigo_ciiuv4: '431100',
  descripcion_ciiuv4: 'Demolición'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '451010',
  codigo_ciiuv4: '431200',
  descripcion_ciiuv4: 'Preparación del terreno'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '432',
  codigo_ciiuv4: '432',
  descripcion_ciiuv4: 'Instalaciones eléctricas, de gasfitería y otras instalaciones para obras de construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '453000',
  codigo_ciiuv4: '432100',
  descripcion_ciiuv4: 'Instalaciones eléctricas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '453000',
  codigo_ciiuv4: '432200',
  descripcion_ciiuv4: 'Instalaciones de gasfitería, calefacción y aire acondicionado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '453000',
  codigo_ciiuv4: '432900',
  descripcion_ciiuv4: 'Otras instalaciones para obras de construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '433',
  codigo_ciiuv4: '433',
  descripcion_ciiuv4: 'Terminación y acabado de edificios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '453000',
  codigo_ciiuv4: '433000',
  descripcion_ciiuv4: 'Terminación y acabado de edificios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '439',
  codigo_ciiuv4: '439',
  descripcion_ciiuv4: 'Otras actividades especializadas de construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '452020',
  codigo_ciiuv4: '439000',
  descripcion_ciiuv4: 'Otras actividades especializadas de construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '45',
  codigo_ciiuv4: '45',
  descripcion_ciiuv4: 'Comercio al por mayor y al por menor y reparación de vehículos automo-tores y motocicletas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '451',
  codigo_ciiuv4: '451',
  descripcion_ciiuv4: 'Venta de vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '501010',
  codigo_ciiuv4: '451001',
  descripcion_ciiuv4: 'Venta al por mayor de vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '501020',
  codigo_ciiuv4: '451002',
  descripcion_ciiuv4: 'Venta al por menor de vehículos automotores nuevos o usados (incluye compraventa)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '452',
  codigo_ciiuv4: '452',
  descripcion_ciiuv4: 'Mantenimiento y reparación de vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '502010',
  codigo_ciiuv4: '452001',
  descripcion_ciiuv4: 'Servicio de lavado de vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '502080',
  codigo_ciiuv4: '452002',
  descripcion_ciiuv4: 'Mantenimiento y reparación de vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '453',
  codigo_ciiuv4: '453',
  descripcion_ciiuv4: 'Venta de partes, piezas y accesorios para vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '503000',
  codigo_ciiuv4: '453000',
  descripcion_ciiuv4: 'Venta de partes, piezas y accesorios para vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '454',
  codigo_ciiuv4: '454',
  descripcion_ciiuv4: 'Venta, mantenimiento y reparación de motocicletas y sus partes, piezas y accesorios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '504010',
  codigo_ciiuv4: '454001',
  descripcion_ciiuv4: 'Venta de motocicletas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '504020',
  codigo_ciiuv4: '454002',
  descripcion_ciiuv4: 'Venta de partes, piezas y accesorios de motocicletas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '504080',
  codigo_ciiuv4: '454003',
  descripcion_ciiuv4: 'Mantenimiento y reparación de motocicletas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '46',
  codigo_ciiuv4: '46',
  descripcion_ciiuv4: 'Comercio al por mayor, excepto el de vehículos automotores y motocicletas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '461',
  codigo_ciiuv4: '461',
  descripcion_ciiuv4: 'Venta al por mayor a cambio de una retribución o por contrata'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '511010',
  codigo_ciiuv4: '461001',
  descripcion_ciiuv4: 'Corretaje al por mayor de productos agrícolas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '511020',
  codigo_ciiuv4: '461002',
  descripcion_ciiuv4: 'Corretaje al por mayor de ganado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '511030',
  codigo_ciiuv4: '461009',
  descripcion_ciiuv4: 'Otros tipos de corretajes o remates al por mayor n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '462',
  codigo_ciiuv4: '462',
  descripcion_ciiuv4: 'Venta al por mayor de materias primas agropecuarias y animales vivos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512130',
  codigo_ciiuv4: '462010',
  descripcion_ciiuv4: 'Venta al por mayor de materias primas agrícolas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512110',
  codigo_ciiuv4: '462020',
  descripcion_ciiuv4: 'Venta al por mayor de animales vivos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512120',
  codigo_ciiuv4: '462090',
  descripcion_ciiuv4: 'Venta al por mayor de otras materias primas agropecuarias n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '463',
  codigo_ciiuv4: '463',
  descripcion_ciiuv4: 'Venta al por mayor de alimentos, bebidas y tabaco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512210',
  codigo_ciiuv4: '463011',
  descripcion_ciiuv4: 'Venta al por mayor de frutas y verduras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512220',
  codigo_ciiuv4: '463012',
  descripcion_ciiuv4: 'Venta al por mayor de carne y productos cárnicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512230',
  codigo_ciiuv4: '463013',
  descripcion_ciiuv4: 'Venta al por mayor de productos del mar (pescados, mariscos y algas)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512250',
  codigo_ciiuv4: '463014',
  descripcion_ciiuv4: 'Venta al por mayor de productos de confitería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512290',
  codigo_ciiuv4: '463019',
  descripcion_ciiuv4: 'Venta al por mayor de huevos, lácteos, abarrotes y de otros alimentos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512240',
  codigo_ciiuv4: '463020',
  descripcion_ciiuv4: 'Venta al por mayor de bebidas alcohólicas y no alcohólicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512260',
  codigo_ciiuv4: '463030',
  descripcion_ciiuv4: 'Venta al por mayor de tabaco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '464',
  codigo_ciiuv4: '464',
  descripcion_ciiuv4: 'Venta al por mayor de enseres domésticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513100',
  codigo_ciiuv4: '464100',
  descripcion_ciiuv4: 'Venta al por mayor de productos textiles, prendas de vestir y calzado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513910',
  codigo_ciiuv4: '464901',
  descripcion_ciiuv4: 'Venta al por mayor de muebles, excepto muebles de oficina'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513920',
  codigo_ciiuv4: '464902',
  descripcion_ciiuv4: 'Venta al por mayor de artículos eléctricos y electrónicos para el hogar'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513930',
  codigo_ciiuv4: '464903',
  descripcion_ciiuv4: 'Venta al por mayor de artículos de perfumería, de tocador y cosméticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513940',
  codigo_ciiuv4: '464904',
  descripcion_ciiuv4: 'Venta al por mayor de artículos de papelería y escritorio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513951',
  codigo_ciiuv4: '464905',
  descripcion_ciiuv4: 'Venta al por mayor de libros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513952',
  codigo_ciiuv4: '464906',
  descripcion_ciiuv4: 'Venta al por mayor de diarios y revistas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513960',
  codigo_ciiuv4: '464907',
  descripcion_ciiuv4: 'Venta al por mayor de productos farmacéuticos y medicinales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513970',
  codigo_ciiuv4: '464908',
  descripcion_ciiuv4: 'Venta al por mayor de instrumentos científicos y quirúrgicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513990',
  codigo_ciiuv4: '464909',
  descripcion_ciiuv4: 'Venta al por mayor de otros enseres domésticos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '465',
  codigo_ciiuv4: '465',
  descripcion_ciiuv4: 'Venta al por mayor de maquinaria, equipo y materiales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515007',
  codigo_ciiuv4: '465100',
  descripcion_ciiuv4: 'Venta al por mayor de computadores, equipo periférico y programas informáticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515007',
  codigo_ciiuv4: '465200',
  descripcion_ciiuv4: 'Venta al por mayor de equipo, partes y piezas electrónicos y de telecomunicaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515001',
  codigo_ciiuv4: '465300',
  descripcion_ciiuv4: 'Venta al por mayor de maquinaria, equipo y materiales agropecuarios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515002',
  codigo_ciiuv4: '465901',
  descripcion_ciiuv4: 'Venta al por mayor de maquinaria metalúrgica, para la minería, extracción de petróleo y construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515005',
  codigo_ciiuv4: '465902',
  descripcion_ciiuv4: 'Venta al por mayor de maquinaria para la elaboración de alimentos, bebidas y tabaco'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515006',
  codigo_ciiuv4: '465903',
  descripcion_ciiuv4: 'Venta al por mayor de maquinaria para la industria textil, del cuero y del calzado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515007',
  codigo_ciiuv4: '465904',
  descripcion_ciiuv4: 'Venta al por mayor de maquinaria y equipo de oficina; venta al por mayor de muebles de oficina'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515008',
  codigo_ciiuv4: '465905',
  descripcion_ciiuv4: 'Venta al por mayor de equipo de transporte(excepto vehículos automotores, motocicletas y bicicletas)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '515009',
  codigo_ciiuv4: '465909',
  descripcion_ciiuv4: 'Venta al por mayor de otros tipos de maquinaria y equipo n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '466',
  codigo_ciiuv4: '466',
  descripcion_ciiuv4: 'Otras actividades de venta al por mayor especializada'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '514110',
  codigo_ciiuv4: '466100',
  descripcion_ciiuv4: 'Venta al por mayor de combustibles sólidos, líquidos y gaseosos y productos conexos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '514200',
  codigo_ciiuv4: '466200',
  descripcion_ciiuv4: 'Venta al por mayor de metales y minerales metalíferos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '514310',
  codigo_ciiuv4: '466301',
  descripcion_ciiuv4: 'Venta al por mayor de madera en bruto y productos primarios de la elaboración de madera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '513990',
  codigo_ciiuv4: '466302',
  descripcion_ciiuv4: 'Venta al por mayor de materiales de construcción, artículos de ferretería, gasfitería y calefacción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '514910',
  codigo_ciiuv4: '466901',
  descripcion_ciiuv4: 'Venta al por mayor de productos químicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '514920',
  codigo_ciiuv4: '466902',
  descripcion_ciiuv4: 'Venta al por mayor de desechos metálicos (chatarra)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '514990',
  codigo_ciiuv4: '466909',
  descripcion_ciiuv4: 'Venta al por mayor de desperdicios, desechos y otros productos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '469',
  codigo_ciiuv4: '469',
  descripcion_ciiuv4: 'Venta al por mayor no especializada'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '519000',
  codigo_ciiuv4: '469000',
  descripcion_ciiuv4: 'Venta al por mayor no especializada'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '47',
  codigo_ciiuv4: '47',
  descripcion_ciiuv4: 'Comercio al por menor, excepto el de vehículos automotores y motocicletas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '471',
  codigo_ciiuv4: '471',
  descripcion_ciiuv4: 'Venta al por menor en comercios no especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '521112',
  codigo_ciiuv4: '471100',
  descripcion_ciiuv4: 'Venta al por menor en comercios de alimentos, bebidas o tabaco (supermercados e hipermercados)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '521300',
  codigo_ciiuv4: '471910',
  descripcion_ciiuv4: 'Venta al por menor en comercios de vestuario y productos para el hogar (grandes tiendas)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '521200',
  codigo_ciiuv4: '471990',
  descripcion_ciiuv4: 'Otras actividades de venta al por menor en comercios no especializados n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '472',
  codigo_ciiuv4: '472',
  descripcion_ciiuv4: 'Venta al por menor de alimentos, bebidas y tabaco en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '521112',
  codigo_ciiuv4: '472101',
  descripcion_ciiuv4: 'Venta al por menor de alimentos en comercios especializados (almacenes pequeños y minimarket)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522020',
  codigo_ciiuv4: '472102',
  descripcion_ciiuv4: 'Venta al por menor en comercios especializados de carne y productos cárnicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522030',
  codigo_ciiuv4: '472103',
  descripcion_ciiuv4: 'Venta al por menor en comercios especializados de frutas y verduras (verdulerías)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522040',
  codigo_ciiuv4: '472104',
  descripcion_ciiuv4: 'Venta al por menor en comercios especializados de pescado, mariscos y productos conexos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522050',
  codigo_ciiuv4: '472105',
  descripcion_ciiuv4: 'Venta al por menor en comercios especializados de productos de panadería y pastelería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522070',
  codigo_ciiuv4: '472109',
  descripcion_ciiuv4: 'Venta al por menor en comercios especializados de huevos, confites y productos alimenticios n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522010',
  codigo_ciiuv4: '472200',
  descripcion_ciiuv4: 'Venta al por menor de bebidas alcohólicas y no alcohólicas en comercios especializados (botillerías)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522090',
  codigo_ciiuv4: '472300',
  descripcion_ciiuv4: 'Venta al por menor de tabaco y productos de tabaco en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '473',
  codigo_ciiuv4: '473',
  descripcion_ciiuv4: 'Venta al por menor de combustibles para vehículos automotores en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '505000',
  codigo_ciiuv4: '473000',
  descripcion_ciiuv4: 'Venta al por menor de combustibles para vehículos automotores en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '474',
  codigo_ciiuv4: '474',
  descripcion_ciiuv4: 'Venta al por menor de equipo de información y de comunicaciones en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523921',
  codigo_ciiuv4: '474100',
  descripcion_ciiuv4: 'Venta al por menor de computadores, equipo periférico, programas informáticos y equipo de telecom.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523310',
  codigo_ciiuv4: '474200',
  descripcion_ciiuv4: 'Venta al por menor de equipo de sonido y de video en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '475',
  codigo_ciiuv4: '475',
  descripcion_ciiuv4: 'Venta al por menor de otros enseres domésticos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523230',
  codigo_ciiuv4: '475100',
  descripcion_ciiuv4: 'Venta al por menor de telas, lanas, hilos y similares en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523410',
  codigo_ciiuv4: '475201',
  descripcion_ciiuv4: 'Venta al por menor de artículos de ferretería y materiales de construcción'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523420',
  codigo_ciiuv4: '475202',
  descripcion_ciiuv4: 'Venta al por menor de pinturas, barnices y lacas en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523430',
  codigo_ciiuv4: '475203',
  descripcion_ciiuv4: 'Venta al por menor de productos de vidrio en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523999',
  codigo_ciiuv4: '475300',
  descripcion_ciiuv4: 'Venta al por menor de tapices, alfombras y cubrimientos para paredes y pisos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523330',
  codigo_ciiuv4: '475901',
  descripcion_ciiuv4: 'Venta al por menor de muebles y colchones en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523340',
  codigo_ciiuv4: '475902',
  descripcion_ciiuv4: 'Venta al por menor de instrumentos musicales en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523320',
  codigo_ciiuv4: '475909',
  descripcion_ciiuv4: 'Venta al por menor de aparatos eléctricos, textiles para el hogar y otros enseres domésticos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '476',
  codigo_ciiuv4: '476',
  descripcion_ciiuv4: 'Venta al por menor de productos culturales y recreativos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523922',
  codigo_ciiuv4: '476101',
  descripcion_ciiuv4: 'Venta al por menor de libros en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523923',
  codigo_ciiuv4: '476102',
  descripcion_ciiuv4: 'Venta al por menor de diarios y revistas en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523924',
  codigo_ciiuv4: '476103',
  descripcion_ciiuv4: 'Venta al por menor de artículos de papelería y escritorio en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523350',
  codigo_ciiuv4: '476200',
  descripcion_ciiuv4: 'Venta al por menor de grabaciones de música y de video en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523941',
  codigo_ciiuv4: '476301',
  descripcion_ciiuv4: 'Venta al por menor de artículos de caza y pesca en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523942',
  codigo_ciiuv4: '476302',
  descripcion_ciiuv4: 'Venta al por menor de bicicletas y sus repuestos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523943',
  codigo_ciiuv4: '476309',
  descripcion_ciiuv4: 'Venta al por menor de otros artículos y equipos de deporte n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523921',
  codigo_ciiuv4: '476400',
  descripcion_ciiuv4: 'Venta al por menor de juegos y juguetes en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '477',
  codigo_ciiuv4: '477',
  descripcion_ciiuv4: 'Venta al por menor de otros productos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523210',
  codigo_ciiuv4: '477101',
  descripcion_ciiuv4: 'Venta al por menor de calzado en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523220',
  codigo_ciiuv4: '477102',
  descripcion_ciiuv4: 'Venta al por menor de prendas y accesorios de vestir en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523240',
  codigo_ciiuv4: '477103',
  descripcion_ciiuv4: 'Venta al por menor de carteras, maletas y otros accesorios de viaje en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523111',
  codigo_ciiuv4: '477201',
  descripcion_ciiuv4: 'Venta al por menor de productos farmacéuticos y medicinales en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523130',
  codigo_ciiuv4: '477202',
  descripcion_ciiuv4: 'Venta al por menor de artículos ortopédicos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523140',
  codigo_ciiuv4: '477203',
  descripcion_ciiuv4: 'Venta al por menor de artículos de perfumería, de tocador y cosméticos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523961',
  codigo_ciiuv4: '477310',
  descripcion_ciiuv4: 'Venta al por menor de gas licuado en bombonas (cilindros) en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522060',
  codigo_ciiuv4: '477391',
  descripcion_ciiuv4: 'Venta al por menor de alimento y accesorios para mascotas en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523941',
  codigo_ciiuv4: '477392',
  descripcion_ciiuv4: 'Venta al por menor de armas y municiones en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523912',
  codigo_ciiuv4: '477393',
  descripcion_ciiuv4: 'Venta al por menor de artículos ópticos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523950',
  codigo_ciiuv4: '477394',
  descripcion_ciiuv4: 'Venta al por menor de artículos de joyería, bisutería y relojería en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523969',
  codigo_ciiuv4: '477395',
  descripcion_ciiuv4: 'Venta al por menor de carbón, leña y otros combustibles de uso doméstico en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523991',
  codigo_ciiuv4: '477396',
  descripcion_ciiuv4: 'Venta al por menor de recuerdos, artesanías y artículos religiosos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523992',
  codigo_ciiuv4: '477397',
  descripcion_ciiuv4: 'Venta al por menor de flores, plantas, arboles, semillas y abonos en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523993',
  codigo_ciiuv4: '477398',
  descripcion_ciiuv4: 'Venta al por menor de mascotas en comercios especializados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '523911',
  codigo_ciiuv4: '477399',
  descripcion_ciiuv4: 'Venta al por menor de otros productos en comercios especializados n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '524010',
  codigo_ciiuv4: '477401',
  descripcion_ciiuv4: 'Venta al por menor de antigüedades en comercios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '524020',
  codigo_ciiuv4: '477402',
  descripcion_ciiuv4: 'Venta al por menor de ropa usada en comercios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '524090',
  codigo_ciiuv4: '477409',
  descripcion_ciiuv4: 'Venta al por menor de otros artículos de segunda mano en comercios n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '478',
  codigo_ciiuv4: '478',
  descripcion_ciiuv4: 'Venta al por menor en puestos de venta y mercados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '525200',
  codigo_ciiuv4: '478100',
  descripcion_ciiuv4: 'Venta al por menor de alimentos, bebidas y tabaco en puestos de venta y mercados (incluye ferias)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '525200',
  codigo_ciiuv4: '478200',
  descripcion_ciiuv4: 'Venta al por menor de productos textiles, prendas de vestir y calzado en puestos de venta y mercados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '525200',
  codigo_ciiuv4: '478900',
  descripcion_ciiuv4: 'Venta al por menor de otros productos en puestos de venta y mercados (incluye ferias)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '479',
  codigo_ciiuv4: '479',
  descripcion_ciiuv4: 'Venta al por menor no realizada en comercios, puestos de venta o mercados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '525110',
  codigo_ciiuv4: '479100',
  descripcion_ciiuv4: 'Venta al por menor por correo, por internet y vía telefónica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '525911',
  codigo_ciiuv4: '479901',
  descripcion_ciiuv4: 'Venta al por menor realizada por independientes en la locomoción colectiva (ley 20.388)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '525920',
  codigo_ciiuv4: '479902',
  descripcion_ciiuv4: 'Venta al por menor mediante maquinas expendedoras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '525930',
  codigo_ciiuv4: '479903',
  descripcion_ciiuv4: 'Venta al por menor por comisionistas (no dependientes de comercios)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '525919',
  codigo_ciiuv4: '479909',
  descripcion_ciiuv4: 'Otras actividades de venta por menor no realizadas en comercios, puestos de venta o mercados n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '49',
  codigo_ciiuv4: '49',
  descripcion_ciiuv4: 'Transporte por vía terrestre y transporte por tuberías'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '491',
  codigo_ciiuv4: '491',
  descripcion_ciiuv4: 'Transporte por ferrocarril'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '601001',
  codigo_ciiuv4: '491100',
  descripcion_ciiuv4: 'Transporte interurbano de pasajeros por ferrocarril'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '601002',
  codigo_ciiuv4: '491200',
  descripcion_ciiuv4: 'Transporte de carga por ferrocarril'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '492',
  codigo_ciiuv4: '492',
  descripcion_ciiuv4: 'Otras actividades de transporte por vía terrestre'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602110',
  codigo_ciiuv4: '492110',
  descripcion_ciiuv4: 'Transporte urbano y suburbano de pasajeros vía metro y metrotren'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602120',
  codigo_ciiuv4: '492120',
  descripcion_ciiuv4: 'Transporte urbano y suburbano de pasajeros vía locomoción colectiva'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602140',
  codigo_ciiuv4: '492130',
  descripcion_ciiuv4: 'Transporte de pasajeros vía taxi colectivo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602190',
  codigo_ciiuv4: '492190',
  descripcion_ciiuv4: 'Otras actividades de transporte urbano y suburbano de pasajeros por vía terrestre n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602150',
  codigo_ciiuv4: '492210',
  descripcion_ciiuv4: 'Servicios de transporte de escolares'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602160',
  codigo_ciiuv4: '492220',
  descripcion_ciiuv4: 'Servicios de transporte de trabajadores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602210',
  codigo_ciiuv4: '492230',
  descripcion_ciiuv4: 'Servicios de transporte de pasajeros en taxis libres y radiotaxis'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602220',
  codigo_ciiuv4: '492240',
  descripcion_ciiuv4: 'Servicios de transporte a turistas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602130',
  codigo_ciiuv4: '492250',
  descripcion_ciiuv4: 'Transporte de pasajeros en buses interurbanos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602190',
  codigo_ciiuv4: '492290',
  descripcion_ciiuv4: 'Otras actividades de transporte de pasajeros por vía terrestre n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602300',
  codigo_ciiuv4: '492300',
  descripcion_ciiuv4: 'Transporte de carga por carretera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '493',
  codigo_ciiuv4: '493',
  descripcion_ciiuv4: 'Transporte por tuberías'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '603000',
  codigo_ciiuv4: '493010',
  descripcion_ciiuv4: 'Transporte por oleoductos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '603000',
  codigo_ciiuv4: '493020',
  descripcion_ciiuv4: 'Transporte por gasoductos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '603000',
  codigo_ciiuv4: '493090',
  descripcion_ciiuv4: 'Otras actividades de transporte por tuberías n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '50',
  codigo_ciiuv4: '50',
  descripcion_ciiuv4: 'Transporte por vía acuática'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '501',
  codigo_ciiuv4: '501',
  descripcion_ciiuv4: 'Transporte marítimo y de cabotaje'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '611001',
  codigo_ciiuv4: '501100',
  descripcion_ciiuv4: 'Transporte de pasajeros marítimo y de cabotaje'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '611002',
  codigo_ciiuv4: '501200',
  descripcion_ciiuv4: 'Transporte de carga marítimo y de cabotaje'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '502',
  codigo_ciiuv4: '502',
  descripcion_ciiuv4: 'Transporte por vías de navegación interiores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '612001',
  codigo_ciiuv4: '502100',
  descripcion_ciiuv4: 'Transporte de pasajeros por vías de navegación interiores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '612002',
  codigo_ciiuv4: '502200',
  descripcion_ciiuv4: 'Transporte de carga por vías de navegación interiores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '51',
  codigo_ciiuv4: '51',
  descripcion_ciiuv4: 'Transporte por vía aérea'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '511',
  codigo_ciiuv4: '511',
  descripcion_ciiuv4: 'Transporte de pasajeros por vía aérea'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '622001',
  codigo_ciiuv4: '511000',
  descripcion_ciiuv4: 'Transporte de pasajeros por vía aérea'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '512',
  codigo_ciiuv4: '512',
  descripcion_ciiuv4: 'Transporte de carga por vía aérea'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '621020',
  codigo_ciiuv4: '512000',
  descripcion_ciiuv4: 'Transporte de carga por vía aérea'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '52',
  codigo_ciiuv4: '52',
  descripcion_ciiuv4: 'Almacenamiento y actividades de apoyo al transporte'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '521',
  codigo_ciiuv4: '521',
  descripcion_ciiuv4: 'Almacenamiento y depósito'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '521001',
  descripcion_ciiuv4: 'Explotación de frigoríficos para almacenamiento y depósito'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630200',
  codigo_ciiuv4: '521009',
  descripcion_ciiuv4: 'Otros servicios de almacenamiento y depósito n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '522',
  codigo_ciiuv4: '522',
  descripcion_ciiuv4: 'Actividades de apoyo al transporte'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630310',
  codigo_ciiuv4: '522110',
  descripcion_ciiuv4: 'Explotación de terminales terrestres de pasajeros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630320',
  codigo_ciiuv4: '522120',
  descripcion_ciiuv4: 'Explotación de estacionamientos de vehículos automotores y parquímetros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630340',
  codigo_ciiuv4: '522130',
  descripcion_ciiuv4: 'Servicios prestados por concesionarios de carreteras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630390',
  codigo_ciiuv4: '522190',
  descripcion_ciiuv4: 'Actividades de servicios vinculadas al transporte terrestre n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630330',
  codigo_ciiuv4: '522200',
  descripcion_ciiuv4: 'Actividades de servicios vinculadas al transporte acuático'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630330',
  codigo_ciiuv4: '522300',
  descripcion_ciiuv4: 'Actividades de servicios vinculadas al transporte aéreo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630100',
  codigo_ciiuv4: '522400',
  descripcion_ciiuv4: 'Manipulación de la carga'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630910',
  codigo_ciiuv4: '522910',
  descripcion_ciiuv4: 'Agencias de aduanas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630920',
  codigo_ciiuv4: '522920',
  descripcion_ciiuv4: 'Agencias de naves'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630920',
  codigo_ciiuv4: '522990',
  descripcion_ciiuv4: 'Otras actividades de apoyo al transporte n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '53',
  codigo_ciiuv4: '53',
  descripcion_ciiuv4: 'Actividades postales y de mensajería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '531',
  codigo_ciiuv4: '531',
  descripcion_ciiuv4: 'Actividades postales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '641100',
  codigo_ciiuv4: '531000',
  descripcion_ciiuv4: 'Actividades postales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '532',
  codigo_ciiuv4: '532',
  descripcion_ciiuv4: 'Actividades de mensajería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '641200',
  codigo_ciiuv4: '532000',
  descripcion_ciiuv4: 'Actividades de mensajería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '55',
  codigo_ciiuv4: '55',
  descripcion_ciiuv4: 'Actividades de alojamiento'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '551',
  codigo_ciiuv4: '551',
  descripcion_ciiuv4: 'Actividades de alojamiento para estancias cortas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '551010',
  codigo_ciiuv4: '551001',
  descripcion_ciiuv4: 'Actividades de hoteles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '551020',
  codigo_ciiuv4: '551002',
  descripcion_ciiuv4: 'Actividades de moteles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '551030',
  codigo_ciiuv4: '551003',
  descripcion_ciiuv4: 'Actividades de residenciales para turistas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '551090',
  codigo_ciiuv4: '551009',
  descripcion_ciiuv4: 'Otras actividades de alojamiento para turistas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '552',
  codigo_ciiuv4: '552',
  descripcion_ciiuv4: 'Actividades de campamentos, parques de vehículos de recreo y parques de caravanas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '551090',
  codigo_ciiuv4: '552000',
  descripcion_ciiuv4: 'Actividades de camping y de parques para casas rodantes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '559',
  codigo_ciiuv4: '559',
  descripcion_ciiuv4: 'Otras actividades de alojamiento'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '551030',
  codigo_ciiuv4: '559001',
  descripcion_ciiuv4: 'Actividades de residenciales para estudiantes y trabajadores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '551090',
  codigo_ciiuv4: '559009',
  descripcion_ciiuv4: 'Otras actividades de alojamiento n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '56',
  codigo_ciiuv4: '56',
  descripcion_ciiuv4: 'Actividades de servicio de comidas y bebidas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '561',
  codigo_ciiuv4: '561',
  descripcion_ciiuv4: 'Actividades de restaurantes y de servicio móvil de comidas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '552010',
  codigo_ciiuv4: '561000',
  descripcion_ciiuv4: 'Actividades de restaurantes y de servicio móvil de comidas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '562',
  codigo_ciiuv4: '562',
  descripcion_ciiuv4: 'Suministro de comidas por encargo y otras actividades de servicio de comidas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '552050',
  codigo_ciiuv4: '562100',
  descripcion_ciiuv4: 'Suministro de comidas por encargo (servicios de banquetería)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '552030',
  codigo_ciiuv4: '562900',
  descripcion_ciiuv4: 'Suministro industrial de comidas por encargo; concesión de servicios de alimentación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '563',
  codigo_ciiuv4: '563',
  descripcion_ciiuv4: 'Actividades de servicio de bebidas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '563001',
  descripcion_ciiuv4: 'Actividades de discotecas y cabaret (night club), con predominio del servicio de bebidas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '552020',
  codigo_ciiuv4: '563009',
  descripcion_ciiuv4: 'Otras actividades de servicio de bebidas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '58',
  codigo_ciiuv4: '58',
  descripcion_ciiuv4: 'Actividades de edición'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '581',
  codigo_ciiuv4: '581',
  descripcion_ciiuv4: 'Edición de libros y publicaciones periódicas y otras actividades de edición'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '581100',
  descripcion_ciiuv4: 'Edición de libros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '581200',
  descripcion_ciiuv4: 'Edición de directorios y listas de correo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '581300',
  descripcion_ciiuv4: 'Edición de diarios, revistas y otras publicaciones periódicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '581900',
  descripcion_ciiuv4: 'Otras actividades de edición'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '582',
  codigo_ciiuv4: '582',
  descripcion_ciiuv4: 'Edición de programas informáticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '582000',
  descripcion_ciiuv4: 'Edición de programas informáticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '59',
  codigo_ciiuv4: '59',
  descripcion_ciiuv4: 'Actividades de producción de películas cinematográficas, videos y pro-gramas de televisión, grabación de sonido y edición de música'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '591',
  codigo_ciiuv4: '591',
  descripcion_ciiuv4: 'Actividades de producción de películas cinematográficas, videos y programas de televisión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '591100',
  descripcion_ciiuv4: 'Actividades de producción de películas cinematográficas, videos y programas de televisión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '591200',
  descripcion_ciiuv4: 'Actividades de postproducción de películas cinematográficas, videos y programas de televisión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '591300',
  descripcion_ciiuv4: 'Actividades de distribución de películas cinematográficas, videos y programas de televisión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '591400',
  descripcion_ciiuv4: 'Actividades de exhibición de películas cinematográficas y cintas de video'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '592',
  codigo_ciiuv4: '592',
  descripcion_ciiuv4: 'Actividades de grabación de sonido y edición de música'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '592000',
  descripcion_ciiuv4: 'Actividades de grabación de sonido y edición de música'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '60',
  codigo_ciiuv4: '60',
  descripcion_ciiuv4: 'Actividades de programación y transmisión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '601',
  codigo_ciiuv4: '601',
  descripcion_ciiuv4: 'Transmisiones de radio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '601000',
  descripcion_ciiuv4: 'Transmisiones de radio'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '602',
  codigo_ciiuv4: '602',
  descripcion_ciiuv4: 'Programación y transmisiones de televisión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '602000',
  descripcion_ciiuv4: 'Programación y transmisiones de televisión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '61',
  codigo_ciiuv4: '61',
  descripcion_ciiuv4: 'Telecomunicaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '611',
  codigo_ciiuv4: '611',
  descripcion_ciiuv4: 'Actividades de telecomunicaciones alámbricas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642010',
  codigo_ciiuv4: '611010',
  descripcion_ciiuv4: 'Telefonía fija'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642030',
  codigo_ciiuv4: '611020',
  descripcion_ciiuv4: 'Telefonía larga distancia'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642040',
  codigo_ciiuv4: '611030',
  descripcion_ciiuv4: 'Televisión de pago por cable'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642050',
  codigo_ciiuv4: '611090',
  descripcion_ciiuv4: 'Otros servicios de telecomunicaciones alámbricas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '612',
  codigo_ciiuv4: '612',
  descripcion_ciiuv4: 'Actividades de telecomunicaciones inalámbricas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642020',
  codigo_ciiuv4: '612010',
  descripcion_ciiuv4: 'Telefonía móvil celular'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642090',
  codigo_ciiuv4: '612020',
  descripcion_ciiuv4: 'Radiocomunicaciones móviles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642040',
  codigo_ciiuv4: '612030',
  descripcion_ciiuv4: 'Televisión de pago inalámbrica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642050',
  codigo_ciiuv4: '612090',
  descripcion_ciiuv4: 'Otros servicios de telecomunicaciones inalámbricas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '613',
  codigo_ciiuv4: '613',
  descripcion_ciiuv4: 'Actividades de telecomunicaciones por satélite'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642020',
  codigo_ciiuv4: '613010',
  descripcion_ciiuv4: 'Telefonía móvil satelital'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642040',
  codigo_ciiuv4: '613020',
  descripcion_ciiuv4: 'Televisión de pago satelital'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642050',
  codigo_ciiuv4: '613090',
  descripcion_ciiuv4: 'Otros servicios de telecomunicaciones por satélite n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '619',
  codigo_ciiuv4: '619',
  descripcion_ciiuv4: 'Otras actividades de telecomunicaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642062',
  codigo_ciiuv4: '619010',
  descripcion_ciiuv4: 'Centros de llamados y centros de acceso a internet'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642090',
  codigo_ciiuv4: '619090',
  descripcion_ciiuv4: 'Otras actividades de telecomunicaciones n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '62',
  codigo_ciiuv4: '62',
  descripcion_ciiuv4: 'Programación informática, consultoría de informática y actividades conexas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '620',
  codigo_ciiuv4: '620',
  descripcion_ciiuv4: 'Actividades de programación informática, consultoría informática y actividades conexas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '722000',
  codigo_ciiuv4: '620100',
  descripcion_ciiuv4: 'Actividades de programación informática'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '724000',
  codigo_ciiuv4: '620200',
  descripcion_ciiuv4: 'Actividades de consultoría de informática y de gestión de instalaciones informáticas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '726000',
  codigo_ciiuv4: '620900',
  descripcion_ciiuv4: 'Otras actividades de tecnología de la información y de servicios informáticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '63',
  codigo_ciiuv4: '63',
  descripcion_ciiuv4: 'Actividades de servicios de información'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '631',
  codigo_ciiuv4: '631',
  descripcion_ciiuv4: 'Procesamiento de datos, hospedaje y actividades conexas; portales web'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '724000',
  codigo_ciiuv4: '631100',
  descripcion_ciiuv4: 'Procesamiento de datos, hospedaje y actividades conexas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '724000',
  codigo_ciiuv4: '631200',
  descripcion_ciiuv4: 'Portales web'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '639',
  codigo_ciiuv4: '639',
  descripcion_ciiuv4: 'Otras actividades de servicios de información'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '639100',
  descripcion_ciiuv4: 'Actividades de agencias de noticias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '639900',
  descripcion_ciiuv4: 'Otras actividades de servicios de información n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '64',
  codigo_ciiuv4: '64',
  descripcion_ciiuv4: 'Actividades de servicios financieros, excepto las de seguros y fondos de pensiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '641',
  codigo_ciiuv4: '641',
  descripcion_ciiuv4: 'Intermediación monetaria'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '651100',
  codigo_ciiuv4: '641100',
  descripcion_ciiuv4: 'Banca central'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '651910',
  codigo_ciiuv4: '641910',
  descripcion_ciiuv4: 'Actividades bancarias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '651990',
  codigo_ciiuv4: '641990',
  descripcion_ciiuv4: 'Otros tipos de intermediación monetaria n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '642',
  codigo_ciiuv4: '642',
  descripcion_ciiuv4: 'Actividades de sociedades de cartera'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659920',
  codigo_ciiuv4: '642000',
  descripcion_ciiuv4: 'Actividades de sociedades de carter'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '643',
  codigo_ciiuv4: '643',
  descripcion_ciiuv4: 'Fondos y sociedades de inversión y entidades financieras similares'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659920',
  codigo_ciiuv4: '643000',
  descripcion_ciiuv4: 'Fondos y sociedades de inversión y entidades financieras similares'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '649',
  codigo_ciiuv4: '649',
  descripcion_ciiuv4: 'Otras actividades de servicios financieros, excepto las de seguros y fondos de pensiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659110',
  codigo_ciiuv4: '649100',
  descripcion_ciiuv4: 'Leasing financiero'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '651920',
  codigo_ciiuv4: '649201',
  descripcion_ciiuv4: 'Financieras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659220',
  codigo_ciiuv4: '649202',
  descripcion_ciiuv4: 'Actividades de crédito prendario'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '649203',
  descripcion_ciiuv4: 'Cajas de compensación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659210',
  codigo_ciiuv4: '649209',
  descripcion_ciiuv4: 'Otras actividades de concesión de crédito n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659231',
  codigo_ciiuv4: '649900',
  descripcion_ciiuv4: 'Otras actividades de servicios financieros, excepto las de seguros y fondos de pensiones n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '65',
  codigo_ciiuv4: '65',
  descripcion_ciiuv4: 'Seguros, reaseguros y fondos de pensiones, excepto planes de seguridad social de afiliación obligatoria'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '651',
  codigo_ciiuv4: '651',
  descripcion_ciiuv4: 'Seguros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '660101',
  codigo_ciiuv4: '651100',
  descripcion_ciiuv4: 'Seguros de vida'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '660301',
  codigo_ciiuv4: '651210',
  descripcion_ciiuv4: 'Seguros generales, excepto actividades de isapres'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '660400',
  codigo_ciiuv4: '651220',
  descripcion_ciiuv4: 'Actividades de isapres'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '652',
  codigo_ciiuv4: '652',
  descripcion_ciiuv4: 'Reaseguros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '660102',
  codigo_ciiuv4: '652000',
  descripcion_ciiuv4: 'Reaseguros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '653',
  codigo_ciiuv4: '653',
  descripcion_ciiuv4: 'Fondos de pensiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '660200',
  codigo_ciiuv4: '653000',
  descripcion_ciiuv4: 'Fondos de pensiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '66',
  codigo_ciiuv4: '66',
  descripcion_ciiuv4: 'Actividades auxiliares de las actividades de servicios financieros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '661',
  codigo_ciiuv4: '661',
  descripcion_ciiuv4: 'Actividades auxiliares de servicios financieros, excepto las de seguros y fondos de pensiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671100',
  codigo_ciiuv4: '661100',
  descripcion_ciiuv4: 'Administración de mercados financieros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659232',
  codigo_ciiuv4: '661201',
  descripcion_ciiuv4: 'Actividades de securitizadoras'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671210',
  codigo_ciiuv4: '661202',
  descripcion_ciiuv4: 'Corredores de bolsa'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671220',
  codigo_ciiuv4: '661203',
  descripcion_ciiuv4: 'Agentes de valores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671940',
  codigo_ciiuv4: '661204',
  descripcion_ciiuv4: 'Actividades de casas de cambio y operadores de divisa'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671290',
  codigo_ciiuv4: '661209',
  descripcion_ciiuv4: 'Otros servicios de corretaje de valores y commodities n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671910',
  codigo_ciiuv4: '661901',
  descripcion_ciiuv4: 'Actividades de cámaras de compensación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671921',
  codigo_ciiuv4: '661902',
  descripcion_ciiuv4: 'Administración de tarjetas de crédito'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671929',
  codigo_ciiuv4: '661903',
  descripcion_ciiuv4: 'Empresas de asesoría y consultoría en inversión financiera; sociedades de apoyo al giro'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671930',
  codigo_ciiuv4: '661904',
  descripcion_ciiuv4: 'Actividades de clasificadoras de riesgo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '671990',
  codigo_ciiuv4: '661909',
  descripcion_ciiuv4: 'Otras actividades auxiliares de las actividades de servicios financieros n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '662',
  codigo_ciiuv4: '662',
  descripcion_ciiuv4: 'Actividades auxiliares de las actividades de seguros y fondos de pensiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '672020',
  codigo_ciiuv4: '662100',
  descripcion_ciiuv4: 'Evaluación de riesgos y daños (incluye actividades de liquidadores de seguros)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '672010',
  codigo_ciiuv4: '662200',
  descripcion_ciiuv4: 'Actividades de agentes y corredores de seguros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '672090',
  codigo_ciiuv4: '662900',
  descripcion_ciiuv4: 'Otras actividades auxiliares de las actividades de seguros y fondos de pensiones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '663',
  codigo_ciiuv4: '663',
  descripcion_ciiuv4: 'Actividades de gestión de fondos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '660200',
  codigo_ciiuv4: '663010',
  descripcion_ciiuv4: 'Administradoras de fondos de pensiones (afp)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659911',
  codigo_ciiuv4: '663091',
  descripcion_ciiuv4: 'Administradoras de fondos de inversión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659912',
  codigo_ciiuv4: '663092',
  descripcion_ciiuv4: 'Administradoras de fondos mutuos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659913',
  codigo_ciiuv4: '663093',
  descripcion_ciiuv4: 'Administradoras de fices (fondos de inversión de capital extranjero)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659914',
  codigo_ciiuv4: '663094',
  descripcion_ciiuv4: 'Administradoras de fondos para la vivienda'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659915',
  codigo_ciiuv4: '663099',
  descripcion_ciiuv4: 'Administradoras de fondos para otros fines n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '68',
  codigo_ciiuv4: '68',
  descripcion_ciiuv4: 'Actividades inmobiliarias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '681',
  codigo_ciiuv4: '681',
  descripcion_ciiuv4: 'Actividades inmobiliarias realizadas con bienes propios o arrendados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '701001',
  codigo_ciiuv4: '681011',
  descripcion_ciiuv4: 'Alquiler de bienes inmuebles amoblados o con equipos y maquinarias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '701009',
  codigo_ciiuv4: '681012',
  descripcion_ciiuv4: 'Compra, venta y alquiler (excepto amoblados) de inmuebles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '701009',
  codigo_ciiuv4: '681020',
  descripcion_ciiuv4: 'Servicios imputados de alquiler de viviendas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '682',
  codigo_ciiuv4: '682',
  descripcion_ciiuv4: 'Actividades inmobiliarias realizadas a cambio de una retribución o por contrata'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '702000',
  codigo_ciiuv4: '682000',
  descripcion_ciiuv4: 'Actividades inmobiliarias realizadas a cambio de una retribución o por contrata'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '69',
  codigo_ciiuv4: '69',
  descripcion_ciiuv4: 'Actividades jurídicas y de contabilidad'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '691',
  codigo_ciiuv4: '691',
  descripcion_ciiuv4: 'Actividades jurídicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741110',
  codigo_ciiuv4: '691001',
  descripcion_ciiuv4: 'Servicios de asesoramiento y representación jurídica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741120',
  codigo_ciiuv4: '691002',
  descripcion_ciiuv4: 'Servicio notarial'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741130',
  codigo_ciiuv4: '691003',
  descripcion_ciiuv4: 'Conservador de bienes raíces'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741140',
  codigo_ciiuv4: '691004',
  descripcion_ciiuv4: 'Receptores judiciales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741190',
  codigo_ciiuv4: '691009',
  descripcion_ciiuv4: 'Servicios de arbitraje; síndicos de quiebra y peritos judiciales; otras actividades jurídicas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '692',
  codigo_ciiuv4: '692',
  descripcion_ciiuv4: 'Actividades de contabilidad, teneduría de libros y auditoría; consultoría fiscal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741200',
  codigo_ciiuv4: '692000',
  descripcion_ciiuv4: 'Actividades de contabilidad, teneduría de libros y auditoría; consultoría fiscal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '70',
  codigo_ciiuv4: '70',
  descripcion_ciiuv4: 'Actividades de oficinas principales; actividades de consultoría de gestión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '701',
  codigo_ciiuv4: '701',
  descripcion_ciiuv4: 'Actividades de oficinas principales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741400',
  codigo_ciiuv4: '701000',
  descripcion_ciiuv4: 'Actividades de oficinas principales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '702',
  codigo_ciiuv4: '702',
  descripcion_ciiuv4: 'Actividades de consultoría de gestión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741400',
  codigo_ciiuv4: '702000',
  descripcion_ciiuv4: 'Actividades de consultoría de gestión'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '71',
  codigo_ciiuv4: '71',
  descripcion_ciiuv4: 'Actividades de arquitectura e ingeniería; ensayos y análisis técnicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '711',
  codigo_ciiuv4: '711',
  descripcion_ciiuv4: 'Actividades de arquitectura e ingeniería y actividades conexas de consultoría técnica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '742110',
  codigo_ciiuv4: '711001',
  descripcion_ciiuv4: 'Servicios de arquitectura (diseño de edificios, dibujo de planos de construcción, entre otros)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '742121',
  codigo_ciiuv4: '711002',
  descripcion_ciiuv4: 'Empresas de servicios de ingeniería y actividades conexas de consultoría técnica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '742122',
  codigo_ciiuv4: '711003',
  descripcion_ciiuv4: 'Servicios profesionales de ingeniería y actividades conexas de consultoría técnica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '712',
  codigo_ciiuv4: '712',
  descripcion_ciiuv4: 'Ensayos y análisis técnicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '742210',
  codigo_ciiuv4: '712001',
  descripcion_ciiuv4: 'Actividades de plantas de revisión técnica para vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '742290',
  codigo_ciiuv4: '712009',
  descripcion_ciiuv4: 'Otros servicios de ensayos y análisis técnicos (excepto actividades de plantas de revisión técnica)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '72',
  codigo_ciiuv4: '72',
  descripcion_ciiuv4: 'Investigación científica y desarrollo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '721',
  codigo_ciiuv4: '721',
  descripcion_ciiuv4: 'Investigaciones y desarrollo experimental en el campo de las ciencias naturales y la ingeniería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '731000',
  codigo_ciiuv4: '721000',
  descripcion_ciiuv4: 'Investigaciones y desarrollo experimental en el campo de las ciencias naturales y la ingeniería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '722',
  codigo_ciiuv4: '722',
  descripcion_ciiuv4: 'Investigaciones y desarrollo experimental en el campo de las ciencias sociales y las humanidades'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '731000',
  codigo_ciiuv4: '722000',
  descripcion_ciiuv4: 'Investigaciones y desarrollo experimental en el campo de las ciencias sociales y las humanidades'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '73',
  codigo_ciiuv4: '73',
  descripcion_ciiuv4: 'Publicidad y estudios de mercado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '731',
  codigo_ciiuv4: '731',
  descripcion_ciiuv4: 'Publicidad'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '743001',
  codigo_ciiuv4: '731001',
  descripcion_ciiuv4: 'Servicios de publicidad prestados por empresas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '743002',
  codigo_ciiuv4: '731002',
  descripcion_ciiuv4: 'Servicios de publicidad prestados por profesionales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '732',
  codigo_ciiuv4: '732',
  descripcion_ciiuv4: 'Estudios de mercado y encuestas de opinión pública'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741300',
  codigo_ciiuv4: '732000',
  descripcion_ciiuv4: 'Estudios de mercado y encuestas de opinión pública'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '74',
  codigo_ciiuv4: '74',
  descripcion_ciiuv4: 'Otras actividades profesionales, científicas y técnicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741',
  codigo_ciiuv4: '741',
  descripcion_ciiuv4: 'Actividades especializadas de diseño'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749921',
  codigo_ciiuv4: '741001',
  descripcion_ciiuv4: 'Actividades de diseño de vestuario'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749922',
  codigo_ciiuv4: '741002',
  descripcion_ciiuv4: 'Actividades de diseño y decoración de interiores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '742141',
  codigo_ciiuv4: '741009',
  descripcion_ciiuv4: 'Otras actividades especializadas de diseño n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '742',
  codigo_ciiuv4: '742',
  descripcion_ciiuv4: 'Actividades de fotografía'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749401',
  codigo_ciiuv4: '742001',
  descripcion_ciiuv4: 'Servicios de revelado, impresión y ampliación de fotografías'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749402',
  codigo_ciiuv4: '742002',
  descripcion_ciiuv4: 'Servicios y actividades de fotografía'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749409',
  codigo_ciiuv4: '742003',
  descripcion_ciiuv4: 'Servicios personales de fotografía'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749',
  codigo_ciiuv4: '749',
  descripcion_ciiuv4: 'Otras actividades profesionales, científicas y técnicas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749913',
  codigo_ciiuv4: '749001',
  descripcion_ciiuv4: 'Asesoría y gestión en la compra o venta de pequeñas y medianas empresas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749933',
  codigo_ciiuv4: '749002',
  descripcion_ciiuv4: 'Servicios de traducción e interpretación prestados por empresas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749932',
  codigo_ciiuv4: '749003',
  descripcion_ciiuv4: 'Servicios personales de traducción e interpretación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749940',
  codigo_ciiuv4: '749004',
  descripcion_ciiuv4: 'Actividades de agencias y agentes de representación de actores, deportistas y otras figuras públicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '742190',
  codigo_ciiuv4: '749009',
  descripcion_ciiuv4: 'Otras actividades profesionales, científicas y técnicas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '75',
  codigo_ciiuv4: '75',
  descripcion_ciiuv4: 'Actividades veterinarias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '750',
  codigo_ciiuv4: '750',
  descripcion_ciiuv4: 'Actividades veterinarias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '852010',
  codigo_ciiuv4: '750001',
  descripcion_ciiuv4: 'Actividades de clínicas veterinarias'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '852021',
  codigo_ciiuv4: '750002',
  descripcion_ciiuv4: 'Actividades de veterinarios, técnicos y otro personal auxiliar, prestados de forma independiente'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '77',
  codigo_ciiuv4: '77',
  descripcion_ciiuv4: 'Actividades de alquiler y arrendamiento'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '771',
  codigo_ciiuv4: '771',
  descripcion_ciiuv4: 'Alquiler y arrendamiento de vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '711101',
  codigo_ciiuv4: '771000',
  descripcion_ciiuv4: 'Alquiler de vehículos automotores sin chofer'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '772',
  codigo_ciiuv4: '772',
  descripcion_ciiuv4: 'Alquiler y arrendamiento de efectos personales y enseres domésticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '713010',
  codigo_ciiuv4: '772100',
  descripcion_ciiuv4: 'Alquiler y arrendamiento de equipo recreativo y deportivo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '713020',
  codigo_ciiuv4: '772200',
  descripcion_ciiuv4: 'Alquiler de cintas de video y discos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '713020',
  codigo_ciiuv4: '772900',
  descripcion_ciiuv4: 'Alquiler de otros efectos personales y enseres domésticos (incluye mobiliario para eventos)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '773',
  codigo_ciiuv4: '773',
  descripcion_ciiuv4: 'Alquiler y arrendamiento de otros tipos de maquinaria, equipo y bienes tangibles'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '711200',
  codigo_ciiuv4: '773001',
  descripcion_ciiuv4: 'Alquiler de equipos de transporte sin operario, excepto vehículos automotores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '712100',
  codigo_ciiuv4: '773002',
  descripcion_ciiuv4: 'Alquiler de maquinaria y equipo agropecuario, forestal, de construcción e ing. civil, sin operarios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '712300',
  codigo_ciiuv4: '773003',
  descripcion_ciiuv4: 'Alquiler de maquinaria y equipo de oficina, sin operarios (sin servicio administrativo)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '712900',
  codigo_ciiuv4: '773009',
  descripcion_ciiuv4: 'Alquiler de otros tipos de maquinarias y equipos sin operario n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '774',
  codigo_ciiuv4: '774',
  descripcion_ciiuv4: 'Arrendamiento de propiedad intelectual y similares, excepto obras protegidas por derechos de autor'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659920',
  codigo_ciiuv4: '774000',
  descripcion_ciiuv4: 'Arrendamiento de propiedad intelectual y similares, excepto obras protegidas por derechos de autor'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '78',
  codigo_ciiuv4: '78',
  descripcion_ciiuv4: 'Actividades de empleo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '781',
  codigo_ciiuv4: '781',
  descripcion_ciiuv4: 'Actividades de agencias de empleo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749190',
  codigo_ciiuv4: '781000',
  descripcion_ciiuv4: 'Actividades de agencias de empleo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '782',
  codigo_ciiuv4: '782',
  descripcion_ciiuv4: 'Actividades de agencias de empleo temporal'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749110',
  codigo_ciiuv4: '782000',
  descripcion_ciiuv4: 'Actividades de agencias de empleo temporal (incluye empresas de servicios transitorios)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '783',
  codigo_ciiuv4: '783',
  descripcion_ciiuv4: 'Otras actividades de dotación de recursos humanos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749110',
  codigo_ciiuv4: '783000',
  descripcion_ciiuv4: 'Otras actividades de dotación de recursos humanos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '79',
  codigo_ciiuv4: '79',
  descripcion_ciiuv4: 'Actividades de agencias de viajes, operadores turísticos, servicios de re-servas y actividades conexas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '791',
  codigo_ciiuv4: '791',
  descripcion_ciiuv4: 'Actividades de agencias de viajes y operadores turísticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630400',
  codigo_ciiuv4: '791100',
  descripcion_ciiuv4: 'Actividades de agencias de viajes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630400',
  codigo_ciiuv4: '791200',
  descripcion_ciiuv4: 'Actividades de operadores turísticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '799',
  codigo_ciiuv4: '799',
  descripcion_ciiuv4: 'Otros servicios de reservas y actividades conexas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '630400',
  codigo_ciiuv4: '799000',
  descripcion_ciiuv4: 'Otros servicios de reservas y actividades conexas (incluye venta de entradas para teatro, y otros)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '80',
  codigo_ciiuv4: '80',
  descripcion_ciiuv4: 'Actividades de seguridad e investigación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '801',
  codigo_ciiuv4: '801',
  descripcion_ciiuv4: 'Actividades de seguridad privada'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749221',
  codigo_ciiuv4: '801001',
  descripcion_ciiuv4: 'Servicios de seguridad privada prestados por empresas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749222',
  codigo_ciiuv4: '801002',
  descripcion_ciiuv4: 'Servicio de transporte de valores en vehículos blindados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749229',
  codigo_ciiuv4: '801003',
  descripcion_ciiuv4: 'Servicios de seguridad privada prestados por independientes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '802',
  codigo_ciiuv4: '802',
  descripcion_ciiuv4: 'Actividades de servicios de sistemas de seguridad'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749221',
  codigo_ciiuv4: '802000',
  descripcion_ciiuv4: 'Actividades de servicios de sistemas de seguridad (incluye servicios de cerrajería)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '803',
  codigo_ciiuv4: '803',
  descripcion_ciiuv4: 'Actividades de investigación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749210',
  codigo_ciiuv4: '803000',
  descripcion_ciiuv4: 'Actividades de investigación (incluye actividades de investigadores y detectives privados)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '81',
  codigo_ciiuv4: '81',
  descripcion_ciiuv4: 'Actividades de servicios a edificios y de paisajismo'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '811',
  codigo_ciiuv4: '811',
  descripcion_ciiuv4: 'Actividades combinadas de apoyo a instalaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '702000',
  codigo_ciiuv4: '811000',
  descripcion_ciiuv4: 'Actividades combinadas de apoyo a instalaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '812',
  codigo_ciiuv4: '812',
  descripcion_ciiuv4: 'Actividades de limpieza'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749310',
  codigo_ciiuv4: '812100',
  descripcion_ciiuv4: 'Limpieza general de edificios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749320',
  codigo_ciiuv4: '812901',
  descripcion_ciiuv4: 'Desratización, desinfección y exterminio de plagas no agrícolas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '900020',
  codigo_ciiuv4: '812909',
  descripcion_ciiuv4: 'Otras actividades de limpieza de edificios e instalaciones industriales n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '813',
  codigo_ciiuv4: '813',
  descripcion_ciiuv4: 'Actividades de paisajismo y servicios de mantenimiento conexos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '900020',
  codigo_ciiuv4: '813000',
  descripcion_ciiuv4: 'Actividades de paisajismo, servicios de jardinería y servicios conexos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '82',
  codigo_ciiuv4: '82',
  descripcion_ciiuv4: 'Actividades administrativas y de apoyo de oficina y otras actividades de apoyo a las empresas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '821',
  codigo_ciiuv4: '821',
  descripcion_ciiuv4: 'Actividades administrativas y de apoyo de oficina'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749931',
  codigo_ciiuv4: '821100',
  descripcion_ciiuv4: 'Actividades combinadas de servicios administrativos de oficina'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749931',
  codigo_ciiuv4: '821900',
  descripcion_ciiuv4: 'Fotocopiado, preparación de documentos y otras actividades especializadas de apoyo de oficina'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '822',
  codigo_ciiuv4: '822',
  descripcion_ciiuv4: 'Actividades de call-center'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749970',
  codigo_ciiuv4: '822000',
  descripcion_ciiuv4: 'Actividades de call-center'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '823',
  codigo_ciiuv4: '823',
  descripcion_ciiuv4: 'Organización de convenciones y exposiciones comerciales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749961',
  codigo_ciiuv4: '823000',
  descripcion_ciiuv4: 'Organización de convenciones y exposiciones comerciales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '829',
  codigo_ciiuv4: '829',
  descripcion_ciiuv4: 'Actividades de servicios de apoyo a las empresas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749911',
  codigo_ciiuv4: '829110',
  descripcion_ciiuv4: 'Actividades de agencias de cobro'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749912',
  codigo_ciiuv4: '829120',
  descripcion_ciiuv4: 'Actividades de agencias de calificación crediticia'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749500',
  codigo_ciiuv4: '829200',
  descripcion_ciiuv4: 'Actividades de envasado y empaquetado'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '749950',
  codigo_ciiuv4: '829900',
  descripcion_ciiuv4: 'Otras actividades de servicios de apoyo a las empresas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '84',
  codigo_ciiuv4: '84',
  descripcion_ciiuv4: 'Administración pública y defensa; planes de seguridad social de afiliación obligatoria'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '841',
  codigo_ciiuv4: '841',
  descripcion_ciiuv4: 'Administración del estado y aplicación de la política económica y social de la comunidad'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '751110',
  codigo_ciiuv4: '841100',
  descripcion_ciiuv4: 'Actividades de la administración pública en general'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '751110',
  codigo_ciiuv4: '841200',
  descripcion_ciiuv4: 'Regulación de las actividades de organismos que prestan servicios sanitarios, educativos, culturales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '751110',
  codigo_ciiuv4: '841300',
  descripcion_ciiuv4: 'Regulación y facilitación de la actividad económica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '842',
  codigo_ciiuv4: '842',
  descripcion_ciiuv4: 'Prestación de servicios a la comunidad en general'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '752100',
  codigo_ciiuv4: '842100',
  descripcion_ciiuv4: 'Relaciones exteriores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '752200',
  codigo_ciiuv4: '842200',
  descripcion_ciiuv4: 'Actividades de defensa'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '751200',
  codigo_ciiuv4: '842300',
  descripcion_ciiuv4: 'Actividades de mantenimiento del orden público y de seguridad'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '843',
  codigo_ciiuv4: '843',
  descripcion_ciiuv4: 'Actividades de planes de seguridad social de afiliación obligatoria'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '753010',
  codigo_ciiuv4: '843010',
  descripcion_ciiuv4: 'Fondo nacional de salud (fonasa)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '753010',
  codigo_ciiuv4: '843020',
  descripcion_ciiuv4: 'Instituto de previsión social (ips)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '753010',
  codigo_ciiuv4: '843090',
  descripcion_ciiuv4: 'Otros planes de seguridad social de afiliación obligatoria n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '85',
  codigo_ciiuv4: '85',
  descripcion_ciiuv4: 'Enseñanza'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '850',
  codigo_ciiuv4: '850',
  descripcion_ciiuv4: 'Enseñanza preescolar, primaria, secundaria científico humanista y técnico profesional'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '801010',
  codigo_ciiuv4: '850011',
  descripcion_ciiuv4: 'Enseñanza preescolar pública'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '801020',
  codigo_ciiuv4: '850012',
  descripcion_ciiuv4: 'Enseñanza primaria, secundaria científico humanista y técnico profesional pública'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '801010',
  codigo_ciiuv4: '850021',
  descripcion_ciiuv4: 'Enseñanza preescolar privada'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '801020',
  codigo_ciiuv4: '850022',
  descripcion_ciiuv4: 'Enseñanza primaria, secundaria científico humanista y técnico profesional privada'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '853',
  codigo_ciiuv4: '853',
  descripcion_ciiuv4: 'Enseñanza superior'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '803010',
  codigo_ciiuv4: '853110',
  descripcion_ciiuv4: 'Enseñanza superior en universidades públicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '803010',
  codigo_ciiuv4: '853120',
  descripcion_ciiuv4: 'Enseñanza superior en universidades privadas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '803020',
  codigo_ciiuv4: '853201',
  descripcion_ciiuv4: 'Enseñanza superior en institutos profesionales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '803030',
  codigo_ciiuv4: '853202',
  descripcion_ciiuv4: 'Enseñanza superior en centros de formación técnica'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '854',
  codigo_ciiuv4: '854',
  descripcion_ciiuv4: 'Otros tipos de enseñanza'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '854100',
  descripcion_ciiuv4: 'Enseñanza deportiva y recreativa'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '921911',
  codigo_ciiuv4: '854200',
  descripcion_ciiuv4: 'Enseñanza cultural'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '809020',
  codigo_ciiuv4: '854901',
  descripcion_ciiuv4: 'Enseñanza preuniversitaria'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '809049',
  codigo_ciiuv4: '854902',
  descripcion_ciiuv4: 'Servicios personales de educación'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '809030',
  codigo_ciiuv4: '854909',
  descripcion_ciiuv4: 'Otros tipos de enseñanza n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '855',
  codigo_ciiuv4: '855',
  descripcion_ciiuv4: 'Actividades de apoyo a la enseñanza'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '741400',
  codigo_ciiuv4: '855000',
  descripcion_ciiuv4: 'Actividades de apoyo a la enseñanza'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '86',
  codigo_ciiuv4: '86',
  descripcion_ciiuv4: 'Actividades de atención de la salud humana'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '861',
  codigo_ciiuv4: '861',
  descripcion_ciiuv4: 'Actividades de hospitales públicos y privados'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851110',
  codigo_ciiuv4: '861010',
  descripcion_ciiuv4: 'Actividades de hospitales y clínicas públicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851110',
  codigo_ciiuv4: '861020',
  descripcion_ciiuv4: 'Actividades de hospitales y clínicas privadas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '862',
  codigo_ciiuv4: '862',
  descripcion_ciiuv4: 'Actividades de médicos y odontólogos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851212',
  codigo_ciiuv4: '862010',
  descripcion_ciiuv4: 'Actividades de centros de salud municipalizados (servicios de salud pública)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851212',
  codigo_ciiuv4: '862021',
  descripcion_ciiuv4: 'Centros médicos privados (establecimientos de atención ambulatoria)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851222',
  codigo_ciiuv4: '862022',
  descripcion_ciiuv4: 'Centros de atención odontológica privados (establecimientos de atención ambulatoria)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851211',
  codigo_ciiuv4: '862031',
  descripcion_ciiuv4: 'Servicios de médicos prestados de forma independiente'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851221',
  codigo_ciiuv4: '862032',
  descripcion_ciiuv4: 'Servicios de odontólogos prestados de forma independiente'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '869',
  codigo_ciiuv4: '869',
  descripcion_ciiuv4: 'Otras actividades de atención de la salud humana'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851910',
  codigo_ciiuv4: '869010',
  descripcion_ciiuv4: 'Actividades de laboratorios clínicos y bancos de sangre'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851990',
  codigo_ciiuv4: '869091',
  descripcion_ciiuv4: 'Otros servicios de atención de la salud humana prestados por empresas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851920',
  codigo_ciiuv4: '869092',
  descripcion_ciiuv4: 'Servicios prestados de forma independiente por otros profesionales de la salud'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '87',
  codigo_ciiuv4: '87',
  descripcion_ciiuv4: 'Actividades de atención en instituciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '871',
  codigo_ciiuv4: '871',
  descripcion_ciiuv4: 'Actividades de atención de enfermería en instituciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851990',
  codigo_ciiuv4: '871000',
  descripcion_ciiuv4: 'Actividades de atención de enfermería en instituciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '872',
  codigo_ciiuv4: '872',
  descripcion_ciiuv4: 'Actividades de atención en instituciones para personas con discapacidad mental y toxicómanos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851990',
  codigo_ciiuv4: '872000',
  descripcion_ciiuv4: 'Actividades de atención en instituciones para personas con discapacidad mental y toxicómanos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '873',
  codigo_ciiuv4: '873',
  descripcion_ciiuv4: 'Actividades de atención en instituciones para personas de edad y personas con discapacidad'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '851990',
  codigo_ciiuv4: '873000',
  descripcion_ciiuv4: 'Actividades de atención en instituciones para personas de edad y personas con discapacidad física'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '879',
  codigo_ciiuv4: '879',
  descripcion_ciiuv4: 'Otras actividades de atención en instituciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '853100',
  codigo_ciiuv4: '879000',
  descripcion_ciiuv4: 'Otras actividades de atención en instituciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '88',
  codigo_ciiuv4: '88',
  descripcion_ciiuv4: 'Actividades de asistencia social sin alojamiento'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '881',
  codigo_ciiuv4: '881',
  descripcion_ciiuv4: 'Actividades de asistencia social sin alojamiento para personas de edad y personas con discapacidad'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '853200',
  codigo_ciiuv4: '881000',
  descripcion_ciiuv4: 'Actividades de asistencia social sin alojamiento para personas de edad y personas con discapacidad'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '889',
  codigo_ciiuv4: '889',
  descripcion_ciiuv4: 'Otras actividades de asistencia social sin alojamiento'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '853200',
  codigo_ciiuv4: '889000',
  descripcion_ciiuv4: 'Otras actividades de asistencia social sin alojamiento'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '90',
  codigo_ciiuv4: '90',
  descripcion_ciiuv4: 'Actividades creativas, artísticas y de entretenimiento'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '900',
  codigo_ciiuv4: '900',
  descripcion_ciiuv4: 'Actividades creativas, artísticas y de entretenimiento'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '921411',
  codigo_ciiuv4: '900001',
  descripcion_ciiuv4: 'Servicios de producción de obras de teatro, conciertos, espectáculos de danza, otras prod. escénicas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '921420',
  codigo_ciiuv4: '900002',
  descripcion_ciiuv4: 'Actividades artísticas realizadas por bandas de música, compañías de teatro, circenses y similares'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '921430',
  codigo_ciiuv4: '900003',
  descripcion_ciiuv4: 'Actividades de artistas realizadas de forma independiente: actores, músicos, escritores, entre otros'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '922002',
  codigo_ciiuv4: '900004',
  descripcion_ciiuv4: 'Servicios prestados por periodistas independientes'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '921411',
  codigo_ciiuv4: '900009',
  descripcion_ciiuv4: 'Otras actividades creativas, artísticas y de entretenimiento n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '91',
  codigo_ciiuv4: '91',
  descripcion_ciiuv4: 'Actividades de bibliotecas, archivos y museos y otras actividades culturales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '910',
  codigo_ciiuv4: '910',
  descripcion_ciiuv4: 'Actividades de bibliotecas, archivos y museos y otras actividades culturales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '923100',
  codigo_ciiuv4: '910100',
  descripcion_ciiuv4: 'Actividades de bibliotecas y archivos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '923200',
  codigo_ciiuv4: '910200',
  descripcion_ciiuv4: 'Actividades de museos, gestión de lugares y edificios históricos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '923300',
  codigo_ciiuv4: '910300',
  descripcion_ciiuv4: 'Actividades de jardines botánicos, zoológicos y reservas naturales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '92',
  codigo_ciiuv4: '92',
  descripcion_ciiuv4: 'Actividades de juegos de azar y apuestas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '920',
  codigo_ciiuv4: '920',
  descripcion_ciiuv4: 'Actividades de juegos de azar y apuestas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924920',
  codigo_ciiuv4: '920010',
  descripcion_ciiuv4: 'Actividades de casinos de juegos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924910',
  codigo_ciiuv4: '920090',
  descripcion_ciiuv4: 'Otras actividades de juegos de azar y apuestas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '93',
  codigo_ciiuv4: '93',
  descripcion_ciiuv4: 'Actividades deportivas, de esparcimiento y recreativas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '931',
  codigo_ciiuv4: '931',
  descripcion_ciiuv4: 'Actividades deportivas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924140',
  codigo_ciiuv4: '931101',
  descripcion_ciiuv4: 'Hipódromos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924930',
  codigo_ciiuv4: '931102',
  descripcion_ciiuv4: 'Gestión de salas de billar; gestión de salas de bolos (bowling)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924110',
  codigo_ciiuv4: '931109',
  descripcion_ciiuv4: 'Gestión de otras instalaciones deportivas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924131',
  codigo_ciiuv4: '931201',
  descripcion_ciiuv4: 'Actividades de clubes de fútbol amateur y profesional'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924120',
  codigo_ciiuv4: '931209',
  descripcion_ciiuv4: 'Actividades de otros clubes deportivos n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924150',
  codigo_ciiuv4: '931901',
  descripcion_ciiuv4: 'Promoción y organización de competencias deportivas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924110',
  codigo_ciiuv4: '931909',
  descripcion_ciiuv4: 'Otras actividades deportivas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '932',
  codigo_ciiuv4: '932',
  descripcion_ciiuv4: 'Otras actividades de esparcimiento y recreativas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '921920',
  codigo_ciiuv4: '932100',
  descripcion_ciiuv4: 'Actividades de parques de atracciones y parques temáticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '924930',
  codigo_ciiuv4: '932901',
  descripcion_ciiuv4: 'Gestión de salas de pool; gestión (explotación) de juegos electrónicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '921912',
  codigo_ciiuv4: '932909',
  descripcion_ciiuv4: 'Otras actividades de esparcimiento y recreativas n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '94',
  codigo_ciiuv4: '94',
  descripcion_ciiuv4: 'Actividades de asociaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '941',
  codigo_ciiuv4: '941',
  descripcion_ciiuv4: 'Actividades de asociaciones empresariales, profesionales y de empleadores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '911100',
  codigo_ciiuv4: '941100',
  descripcion_ciiuv4: 'Actividades de asociaciones empresariales y de empleadores'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '911210',
  codigo_ciiuv4: '941200',
  descripcion_ciiuv4: 'Actividades de asociaciones profesionales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '942',
  codigo_ciiuv4: '942',
  descripcion_ciiuv4: 'Actividades de sindicatos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '912000',
  codigo_ciiuv4: '942000',
  descripcion_ciiuv4: 'Actividades de sindicatos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '949',
  codigo_ciiuv4: '949',
  descripcion_ciiuv4: 'Actividades de otras asociaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '919100',
  codigo_ciiuv4: '949100',
  descripcion_ciiuv4: 'Actividades de organizaciones religiosas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '919200',
  codigo_ciiuv4: '949200',
  descripcion_ciiuv4: 'Actividades de organizaciones políticas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '919910',
  codigo_ciiuv4: '949901',
  descripcion_ciiuv4: 'Actividades de centros de madres'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '919920',
  codigo_ciiuv4: '949902',
  descripcion_ciiuv4: 'Actividades de clubes sociales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '919930',
  codigo_ciiuv4: '949903',
  descripcion_ciiuv4: 'Fundaciones y corporaciones; asociaciones que promueven actividades culturales o recreativas'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '950002',
  codigo_ciiuv4: '949904',
  descripcion_ciiuv4: 'Consejo de administración de edificios y condominios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '659920',
  codigo_ciiuv4: '949909',
  descripcion_ciiuv4: 'Actividades de otras asociaciones n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '95',
  codigo_ciiuv4: '95',
  descripcion_ciiuv4: 'Reparación de computadores y de efectos personales y enseres domésticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '951',
  codigo_ciiuv4: '951',
  descripcion_ciiuv4: 'Reparación de computadores y equipo de comunicaciones'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '725000',
  codigo_ciiuv4: '951100',
  descripcion_ciiuv4: 'Reparación de computadores y equipo periférico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '951200',
  descripcion_ciiuv4: 'Reparación de equipo de comunicaciones (incluye la reparación teléfonos celulares)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '952',
  codigo_ciiuv4: '952',
  descripcion_ciiuv4: 'Reparación de efectos personales y enseres domésticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '952100',
  descripcion_ciiuv4: 'Reparación de aparatos electrónicos de consumo (incluye aparatos de televisión y radio)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '952200',
  descripcion_ciiuv4: 'Reparación de aparatos de uso doméstico, equipo doméstico y de jardinería'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '952300',
  descripcion_ciiuv4: 'Reparación de calzado y de artículos de cuero'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '952400',
  descripcion_ciiuv4: 'Reparación de muebles y accesorios domésticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '952900',
  descripcion_ciiuv4: 'Reparación de otros efectos personales y enseres domésticos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '96',
  codigo_ciiuv4: '96',
  descripcion_ciiuv4: 'Otras actividades de servicios personales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '960',
  codigo_ciiuv4: '960',
  descripcion_ciiuv4: 'Otras actividades de servicios personales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '930100',
  codigo_ciiuv4: '960100',
  descripcion_ciiuv4: 'Lavado y limpieza, incluida la limpieza en seco, de productos textiles y de piel'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '930200',
  codigo_ciiuv4: '960200',
  descripcion_ciiuv4: 'Peluquería y otros tratamientos de belleza'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '930330',
  codigo_ciiuv4: '960310',
  descripcion_ciiuv4: 'Servicios funerarios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '930320',
  codigo_ciiuv4: '960320',
  descripcion_ciiuv4: 'Servicios de cementerios'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '?',
  codigo_ciiuv4: '960901',
  descripcion_ciiuv4: 'Servicios de adiestramiento, guardería, peluquería, paseo de mascotas (excepto act. veterinarias)'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '930910',
  codigo_ciiuv4: '960902',
  descripcion_ciiuv4: 'Actividades de salones de masajes, baños turcos, saunas, servicio de baños públicos'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '930990',
  codigo_ciiuv4: '960909',
  descripcion_ciiuv4: 'Otras actividades de servicios personales n.c.p.'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '97',
  codigo_ciiuv4: '97',
  descripcion_ciiuv4: 'Actividades de los hogares como empleadores de personal doméstico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '970',
  codigo_ciiuv4: '970',
  descripcion_ciiuv4: 'Actividades de los hogares como empleadores de personal doméstico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '950001',
  codigo_ciiuv4: '970000',
  descripcion_ciiuv4: 'Actividades de los hogares como empleadores de personal doméstico'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '99',
  codigo_ciiuv4: '99',
  descripcion_ciiuv4: 'Actividades de organizaciones y órganos extraterritoriales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '990',
  codigo_ciiuv4: '990',
  descripcion_ciiuv4: 'Actividades de organizaciones y órganos extraterritoriales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save
act = {
  codigo_ciiuv2: '990000',
  codigo_ciiuv4: '990000',
  descripcion_ciiuv4: 'Actividades de organizaciones y órganos extraterritoriales'
}
_act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2],codigo_ciiuv4: act[:codigo_ciiuv4])
if _act.nil?
  _act = ActividadEconomica.find_by(codigo_ciiuv2: act[:codigo_ciiuv2])
  if _act.nil?
    _act = ActividadEconomica.new(codigo_ciiuv4: act[:codigo_ciiuv4])
  else
    _act = _act.dup
  end
end
_act.assign_attributes(act)
_act.save