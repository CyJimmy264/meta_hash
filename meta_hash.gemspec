lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "meta_hash/version"

Gem::Specification.new do |spec|
  spec.name          = "meta_hash"
  spec.version       = MetaHash::VERSION
  spec.authors       = ["Maksim Veynberg"]
  spec.email         = ["mv@cj264.ru"]

  spec.summary       = %q{The #MetaHash Ruby library.}
  spec.description   = %q{The #MetaHash Ruby library.}
  spec.homepage      = "https://github.com/CyJimmy264/meta_hash"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.a"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency 'filelock', '~> 1.1'
end
