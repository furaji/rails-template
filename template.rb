def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# Gemfile
gem 'config'
gem 'reform-rails'
gem 'slim-rails'

gem_group :development do
  gem 'annotate'
  gem 'bullet'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'guard-slimlint', require: false
  gem 'rails_best_practices'
  gem 'rubocop', require: false
  gem 'slim_lint', require: false
end

gem_group :development, :test do
  gem 'rspec-parameterized'
  gem 'rspec-rails'
end

after_bundle do
  run 'spring stop'

  generate 'config:install'

  run 'bundle exec guard init'
  run 'bundle exec guard init rspec'
  run 'bundle exec guard init rubocop'

  run 'rails_best_practices -g'
end

copy_file 'files/config/initializers/time_zone.rb', 'config/initializers/time_zone.rb'
copy_file 'files/config/initializers/time_formats.rb', 'config/initializers/time_formats.rb'
copy_file 'files/config/initializers/locale.rb', 'config/initializers/locale.rb'

copy_file 'files/config/locales/ja.yml', 'config/locales/ja.yml'
remove_file 'config/locales/en.yml'

environment do
  %(
    config.generators do |g|
      g.assets false
      g.helper false
      g.view_specs false
      g.routing_specs false
      g.system_tests false
      g.jbuilder false
    end
  )
end

environment nil, env: 'development' do
  %(
    config.after_initialize do
      Bullet.enable = true
      Bullet.alert = false
      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.rails_logger = true
    end
  )
end

# Bootstrap
apply 'recipes/bootstrap.rb'

# Carrierwave
if yes?('Would you like to install carrierwave? (y/n)')
  gem 'carrierwave', '~> 1.0'
end

# Kaminari
gem 'kaminari'
after_bundle do
  generate 'kaminari:config'
end

# RSpec
generate 'rspec:install'

copy_file 'files/.rspec', '.rspec', force: true

remove_dir 'test'
