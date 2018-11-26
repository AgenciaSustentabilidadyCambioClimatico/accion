Dir[File.join(Rails.root, "lib", "gblib", "*.rb")].each {|l| require l }
#EXTERNAL_CONFIG = YAML.load_file(Rails.root.join('config', 'external.yml'))[Rails.env]