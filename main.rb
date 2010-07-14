# rails new appname -JT -d mysql -m rails3_template/main.rb

domain = ask("What's your site domain? Ex.: site.com")
email = ask("What's your email?")
password = ask("What's your password?")

##### clean #####
run "rm README public/index.html public/images/rails.png public/javascripts/* doc/README_FOR_APP"

##### rvm #####
run "echo \"rvm ruby-1.8.7-p299@rails3\" > .rvmrc"

##### .gitignore #####
file ".gitignore", File.read("#{File.dirname(__FILE__)}/gitignore")

##### gems #####
gem "devise", "1.1.rc2"
gem "rspec-rails", "2.0.0.beta.17", :group => [:test, :development]
gem "capybara", "0.3.9", :group => :test
gem "launchy", "0.3.5", :group => :test
gem "factory_girl_rails", :group => :test
gem "remarkable_activerecord", "4.0.0.alpha4", :group => :test
gem "autotest", "4.3.2", :group => [:test, :development]
gem "autotest-rails", "4.1.0", :group => [:test, :development]
gem "show_for", "0.2.2"
gem "friendly_id", "3.0.6"
gem "will_paginate", "3.0.pre"
run "bundle install"

##### rspec #####
generate "rspec:install"

##### home #####
generate "controller home index"
gsub_file "config/routes.rb", '  get "home/index"', ""
route "root :to => 'home#index'"
run "rm spec/helpers/home_helper_spec.rb"
run "rm -rf spec/views/home"

##### layout #####
gsub_file "app/views/layouts/application.html.erb", '<%= yield %>', '<p class="notice"><%= notice %></p>\n<p class="alert"><%= alert %></p>\n\n<%= yield %>'

##### devise #####
generate "devise:install"
file "config/locales/pt-BR.yml", File.read("#{File.dirname(__FILE__)}/config/locales/pt-BR.yml")
file "app/helpers/devise_helper.rb", File.read("#{File.dirname(__FILE__)}/app/helpers/devise_helper.rb")
gsub_file "config/environments/development.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\nend"
gsub_file "config/environments/test.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\nend"
gsub_file "config/environments/production.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => '#{domain}' }\nend"

# generate "devise User"
file "app/models/user.rb", File.read("#{File.dirname(__FILE__)}/app/models/user.rb")
file "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_devise_create_users.rb", File.read("#{File.dirname(__FILE__)}/db/migrate/devise_create_users.rb")
route "devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'sair' }"

generate "devise:views"

gsub_file "config/initializers/devise.rb", '  config.mailer_sender = "please-change-me@config-initializers-devise.com"', "  config.mailer_sender = \"#{email}\""
gsub_file "config/initializers/devise.rb", "  # config.use_default_scope = true", "  config.use_default_scope = true"
gsub_file "config/initializers/devise.rb", "  # config.default_scope = :user", "  config.default_scope = :user"
gsub_file "config/initializers/devise.rb", "  # config.confirm_within = 2.days", "  config.confirm_within = 2.days"

gsub_file "app/views/devise/confirmations/new.html.erb", "confirmation_path(resource_name)", "send_confirmation_path"
gsub_file "app/views/devise/passwords/edit.html.erb", "password_path(resource_name)", "change_password_path"
gsub_file "app/views/devise/passwords/new.html.erb", "password_path(resource_name)", "recover_password_path"
gsub_file "app/views/devise/registrations/edit.html.erb", "registration_path(resource_name)", "account_path"
gsub_file "app/views/devise/registrations/new.html.erb", "registration_path(resource_name)", "signup_path"
gsub_file "app/views/devise/sessions/new.html.erb", "session_path(resource_name)", "login_path"

gsub_file "app/views/devise/registrations/new.html.erb", 'f.submit "Sign up"', 'f.submit "Criar conta"'
gsub_file "app/views/devise/sessions/new.html.erb", 'f.submit "Sign in"', 'f.submit "Login"'


##### routes devise #####
route "match 'login' => 'devise/sessions#new', :via => :get, :as => :login"
route "match 'login' => 'devise/sessions#create', :via => :post, :as => :login"
route "match 'sair' => 'devise/sessions#destroy', :via => :get, :as => :logout"
route "match 'criar-conta' => 'devise/registrations#new', :via => :get, :as => :signup"
route "match 'criar-conta' => 'devise/registrations#create', :via => :post, :as => :signup"
route "match 'minha-conta' => 'devise/registrations#edit', :via => :get, :as => :account"
route "match 'minha-conta' => 'devise/registrations#update', :via => :put, :as => :account"
route "match 'cancelar-conta' => 'devise/registrations#destroy', :via => :post, :as => :cancel_account"
route "match 'recuperar-senha' => 'devise/passwords#new', :via => :get, :as => :recover_password"
route "match 'recuperar-senha' => 'devise/passwords#create', :via => :post, :as => :recover_password"
route "match 's/:reset_password_token' => 'devise/passwords#new', :via => :get, :as => :reset_password"
route "match 'alterar-senha' => 'devise/passwords#edit', :via => :get, :as => :change_password"
route "match 'alterar-senha' => 'devise/passwords#update', :via => :put, :as => :change_password"
route "match 'enviar-confirmacao' => 'devise/confirmations#new', :via => :put, :as => :send_confirmation"
route "match 'enviar-confirmacao' => 'devise/confirmations#create', :via => :post, :as => :send_confirmation"
route "match 'c/:confirmation_token' => 'devise/confirmations#show', :via => :get, :as => :confirmation"

##### capybara #####
file "spec/support/request_example_group.rb", File.read("#{File.dirname(__FILE__)}/spec/support/request_example_group.rb")
file "spec/support/capybara_matchers.rb", File.read("#{File.dirname(__FILE__)}/spec/support/capybara_matchers.rb")

##### specs #####
file "spec/factories/users.rb", File.read("#{File.dirname(__FILE__)}/spec/factories/users.rb")
file "spec/requests/signup_spec.rb", File.read("#{File.dirname(__FILE__)}/spec/requests/signup_spec.rb")
file "spec/requests/login_spec.rb", File.read("#{File.dirname(__FILE__)}/spec/requests/login_spec.rb")

##### show_for #####
generate "show_for_install"

##### config #####
gsub_file "config/application.rb", "    # config.i18n.default_locale = :de", "    config.i18n.default_locale = 'pt-BR'"

##### jquery #####
get "http://code.jquery.com/jquery-1.4.2.min.js", "public/javascripts/jquery/jquery-1.4.2.min.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

##### email #####
gsub_file "config/environments/development.rb", /^end$/, <<-END

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "#{email.split('@')[1]}",
    :user_name            => "#{email}",
    :password             => "#{password}",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }

end

END

##### db #####
rake "db:create:all"
rake "db:migrate"
rake "db:test:prepare"

##### git #####
git :init
git :add => "."
git :commit => "-am 'Initial commit'"
