# frozen_string_literal: true

require_relative "lib/easy_ml/version"

Gem::Specification.new do |spec|
  spec.name = "easy_ml"
  spec.version = EasyMl::VERSION
  spec.authors = ["Andersen Fan"]
  spec.email = ["as181920@gmail.com"]

  spec.summary = "Machine learning algorithms"
  spec.description = "Algorithm collection"
  spec.homepage = "https://github.com/as181920/easy_ml"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/as181920/easy_ml"
  spec.metadata["changelog_uri"] = "https://github.com/as181920/easy_ml/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "matrix"
end
