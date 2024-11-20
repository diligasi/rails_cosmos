# frozen_string_literal: true

require_relative "lib/rails_cosmos/version"

Gem::Specification.new do |spec|
  spec.name = "rails_cosmos"
  spec.version = RailsCosmos::VERSION
  spec.authors = ["Diogo de Lima"]
  spec.email = ["diligasi@gmail.com"]

  spec.summary = "A gem for the COSMOS architecture"
  spec.description = "COSMOS provides a clean and organized structure for API-driven applications, implementing Controllers, Operations, Services, Models, and Serializers."
  spec.homepage = "https://rubygems.org/gems/rails_cosmos"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"
  spec.post_install_message = <<~MSG

    ### Setting up RailsCosmos ###
  
    Thank you for installing RailsCosmos! 🚀
  
    To start using the COSMOS architecture in your Rails project, you'll need to run the setup generator. 
    This will create the base structure for your operations and services, setting up everything you need to follow the COSMOS pattern.
  
    Run `bin/rails g rails_cosmos:install` to initialize the COSMOS architecture in your app.
  
    For more details on how to use and customize RailsCosmos, please refer to the documentation: https://github.com/diligasi/rails_cosmos
    You can also check out the CHANGELOG for recent updates: https://github.com/diligasi/rails_cosmos/blob/main/CHANGELOG.md
  
    Happy coding with COSMOS! ✨

  MSG

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/diligasi/rails_cosmos"
  spec.metadata["changelog_uri"] = "https://github.com/diligasi/rails_cosmos/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 7.0"
  spec.add_dependency "faraday", "~> 1.10.4"
  spec.add_dependency "faraday_middleware", "~> 1.2", ">= 1.2.1"
  spec.add_dependency "typhoeus", "~> 1.4", ">= 1.4.1"

  spec.add_development_dependency "generator_spec", "~> 0.10.0"
end
