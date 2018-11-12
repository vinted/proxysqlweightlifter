
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "proxysqlweightlifter/version"

Gem::Specification.new do |spec|
  spec.name          = "proxysqlweightlifter"
  spec.version       = Proxysqlweightlifter::VERSION
  spec.authors       = ["Ernestas Poskus"]
  spec.email         = ["ernestas@vinted.com"]

  spec.summary       = %q{ProxySQL mysql_servers table automatic weight lifter for reader hosts}
  spec.description   = %q{ProxySQL mysql_servers table automatic weight lifter for reader hosts}
  spec.homepage      = "https://github.com/vinted/proxysqlweightlifter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/vinted/proxysqlweightlifter"
    spec.metadata["changelog_uri"] = "https://github.com/vinted/proxysqlweightlifter/"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = %w[proxysqlweightlifter]
  spec.require_paths = ["lib"]
  spec.files = Dir['lib/**/*.rb']

  spec.add_development_dependency 'mysql2', '~> 0.5.2'
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
