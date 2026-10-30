Gem::Specification.new do |s|
  s.name        = 'puredocx'
  s.version     = '0.0.2'
  s.summary     = 'PureDocx gem patched for RubyZip >= 3.4.0'
  s.authors     = ['Patched']
  s.files       = Dir['lib/**/*']
  s.add_runtime_dependency 'rubyzip', '>= 3.4.0'
end
