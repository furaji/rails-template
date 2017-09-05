if yes?('Would you like to install bootstrap? (y/n)')
  if yes?('Would you like to install simple_form? (y/n)')
    gem 'simple_form'

    after_bundle do
      run 'spring stop'
      generate 'simple_form:install --bootstrap'

      copy_file 'files/config/locales/simple_form.ja.yml', 'config/locales/simple_form.ja.yml'
      remove_file 'config/locales/simple_form.en.yml'
    end
  end

  gem 'bootstrap-sass'
  gem 'bootstrap-sass-extras'
  gem 'bootswatch-rails'
  gem 'jquery-rails'

  after_bundle do
    run 'spring stop'

    layout_name = ask('Please enter layout name:')
    generate "bootstrap:layout #{layout_name}"
  end
end
