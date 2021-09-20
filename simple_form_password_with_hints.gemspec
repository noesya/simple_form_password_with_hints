lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_form_password_with_hints/version"

Gem::Specification.new do |s|
  s.name        = 'simple_form_password_with_hints'
  s.version     = SimpleFormPasswordWithHints::VERSION
  s.summary     = "Simple Form Password with Hints"
  s.description = "Improve Simple Form basic password field, add controls on the field."
  s.authors     = ["Pierre-andré Boissinot"]
  s.email       = 'pa@boissinot.paris'
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.require_paths = ['lib']
  s.homepage    =
    'https://github.com/noesya/simple_form_password_with_hints'
  s.license       = 'MIT'

  s.add_development_dependency "rails", '>= 5.2.0', '< 7'
  s.add_runtime_dependency "bootstrap"
  s.add_runtime_dependency "simple_form"
end
