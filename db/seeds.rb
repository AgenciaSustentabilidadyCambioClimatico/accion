# DZC 2019-07-12 17:11:59 permite leer distintos archivos de seed
Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end