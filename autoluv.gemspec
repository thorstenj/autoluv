Gem::Specification.new do |s|
  s.name        = "autoluv"
  s.version     = "0.0.1.alpha"
  s.summary     = "Schedule and check into Southwest flights from the command line."
  s.author      = "Alex Tran"
  s.email       = "hello@alextran.org"
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"

  s.require_paths = ["lib"]
  s.files       = ["lib/autoluv.rb", "lib/autoluv/southwest.rb", "lib/autoluv/flight.rb", "data/iata-america.tzmap", "schemas/definitions.json", "schemas/schema_flightcheckin_new.json", "schemas/schema_getallboardingpass.json", "schemas/schema_viewairreservation.json", "schemas/schema_viewboardingpass.json"]
  s.bindir      = "bin"
  s.executables << "autoluv"

  s.add_runtime_dependency "rest-client", "~> 1.8"
  s.add_runtime_dependency "json-schema", "~> 2.5"
  s.add_runtime_dependency "commander", "~> 4.3"
  s.add_runtime_dependency "tzinfo", "~> 1.2"
  s.required_ruby_version = "~> 2.0"
end