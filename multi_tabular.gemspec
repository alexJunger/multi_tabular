Gem::Specification.new do |s|
  s.name =        %q{multi_tabular}
  s.version =     '0.2.0'
  s.date =        %q{2015-02-19}
  s.authors =     ['Alexander Junger']
  s.email =       'hello@alexanderjunger.at'
  s.summary =     %q{True multi table inheritance for ActiveRecord.}
  s.description = %q{Facilitates true multi table inheritance of ActiveRecord models by providing methods for
super- and subclasses as well as models with a foreign-key association to MTI records.}
  s.license =     'MIT'
  s.files = [
      'Gemfile',
      'lib/multi_tabular/references.rb',
      'lib/multi_tabular/super.rb',
      'lib/multi_tabular/version.rb',
      'lib/multi_tabular.rb'
  ]
  s.required_ruby_version = '>= 2.0'
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', '~> 4.1'
  s.add_dependency 'activerecord', '~> 4.1'
end

