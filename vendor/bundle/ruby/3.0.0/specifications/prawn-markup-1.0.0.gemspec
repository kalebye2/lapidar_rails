# -*- encoding: utf-8 -*-
# stub: prawn-markup 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "prawn-markup".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Pascal Zumkehr".freeze]
  s.bindir = "exe".freeze
  s.date = "2023-06-14"
  s.description = "Adds simple HTML snippets into Prawn-generated PDFs. All elements are layouted vertically using Prawn's formatting options. A major use case for this gem is to include WYSIWYG-generated HTML parts into server-generated PDF documents.".freeze
  s.email = ["zumkehr@puzzle.ch".freeze]
  s.homepage = "https://github.com/puzzle/prawn-markup".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.5".freeze
  s.summary = "Parse simple HTML markup to include in Prawn PDFs".freeze

  s.installed_by_version = "3.3.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<nokogiri>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<prawn>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<prawn-table>.freeze, [">= 0"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_development_dependency(%q<matrix>.freeze, [">= 0"])
    s.add_development_dependency(%q<pdf-inspector>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
  else
    s.add_dependency(%q<nokogiri>.freeze, [">= 0"])
    s.add_dependency(%q<prawn>.freeze, [">= 0"])
    s.add_dependency(%q<prawn-table>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_dependency(%q<matrix>.freeze, [">= 0"])
    s.add_dependency(%q<pdf-inspector>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
  end
end
