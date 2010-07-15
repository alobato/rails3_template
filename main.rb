domain = ask("What's your site domain? Ex.: site.com")
clean = yes?("Clean the rails public files? [yn]")
sgit = yes?("Setup git? (.gitignore, git init, add, initial commit) [yn]")
rvm = ask("What's project RVM? (Ex.: ruby-1.8.7-p299@rails3) Blank for none. ")
devise = ask("Setup devise?\n[0] No\n[1] English version\n[2] Portuguese version")
rspec = ask("Setup RSpec?\n[0] No\n[1] Yes.\n[2] Yes, with Capybara")
jquery = yes?("Setup JQuery? [yn]")
if gmail = yes?("Setup Gmail in development? [yn]")
  email = ask("What's your email?")
  password = ask("What's your password?")
end
portuguese = yes?("Setup portuguese locale? [yn]")

##### rvm #####
unless rvm.blank?
  run "echo \"rvm #{rvm}\" > .rvmrc"
end

########## GEMS ##########

##### devise gem #####
unless devise == '0'
  gem "devise", "1.1.rc2"
end

unless rspec == '0'
  gem "rspec-rails", "2.0.0.beta.17", :group => [:test, :development]
  gem "autotest", "4.3.2", :group => [:test, :development]
  gem "autotest-rails", "4.1.0", :group => [:test, :development]
  gem "factory_girl_rails", :group => :test
  gem "remarkable_activerecord", "4.0.0.alpha4", :group => :test
end

if rspec == '2' # capybara
  gem "capybara", "0.3.9", :group => :test
  gem "launchy", "0.3.5", :group => :test
end

# gem "show_for", "0.2.2"
# gem "friendly_id", "3.0.6"
# gem "will_paginate", "3.0.pre"

run "bundle install"

##########################

##### rspec #####
unless rspec == '0'
  generate "rspec:install"
  file ".rspec", File.read("#{File.dirname(__FILE__)}/rspec")
end

##### capybara #####
if rspec == '2' # capybara
  file "spec/support/capybara_helper.rb", File.read("#{File.dirname(__FILE__)}/spec/support/capybara_helper.rb")
  file "spec/support/capybara_matchers.rb", File.read("#{File.dirname(__FILE__)}/spec/support/capybara_matchers.rb")
end

##### devise #####
unless devise == '0'
  generate "devise:install"
  gsub_file "config/environments/development.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\nend"
  gsub_file "config/environments/test.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\nend"
  gsub_file "config/environments/production.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => '#{domain}' }\nend"
  ## home ##
  generate "controller home index"
  gsub_file "config/routes.rb", '  get "home/index"', ""
  route "root :to => 'home#index'"
  run "rm spec/helpers/home_helper_spec.rb"
  run "rm -rf spec/views/home"
  ## layout ##
  gsub_file "app/views/layouts/application.html.erb", '<%= yield %>', "<p class=\"notice\"><%= notice %></p>\n<p class=\"alert\"><%= alert %></p>\n\n<%= yield %>"
  # generate "devise User"
  file "app/models/user.rb", File.read("#{File.dirname(__FILE__)}/app/models/user.rb")
  file "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_devise_create_users.rb", File.read("#{File.dirname(__FILE__)}/db/migrate/devise_create_users.rb")

  gsub_file "config/initializers/devise.rb", '  config.mailer_sender = "please-change-me@config-initializers-devise.com"', "  config.mailer_sender = \"#{email}\""
  gsub_file "config/initializers/devise.rb", "  # config.use_default_scope = true", "  config.use_default_scope = true"
  gsub_file "config/initializers/devise.rb", "  # config.default_scope = :user", "  config.default_scope = :user"
  gsub_file "config/initializers/devise.rb", "  # config.confirm_within = 2.days", "  config.confirm_within = 2.days"

  generate "devise:views"
  ## specs ##
  file "spec/factories/users.rb", File.read("#{File.dirname(__FILE__)}/spec/factories/users.rb")
  file "spec/requests/signup_spec.rb", File.read("#{File.dirname(__FILE__)}/spec/requests/signup_spec.rb")
  file "spec/requests/login_spec.rb", File.read("#{File.dirname(__FILE__)}/spec/requests/login_spec.rb")
end

if devise == '1'# english
  # generate "devise User"
  route "devise_for :users"
end

if devise == '2'# portuguese
  file "config/locales/pt-BR.yml", File.read("#{File.dirname(__FILE__)}/config/locales/pt-BR.yml")
  file "app/helpers/devise_helper.rb", File.read("#{File.dirname(__FILE__)}/app/helpers/devise_helper.rb")  
  # generate "devise User"
  route "devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'sair' }"
  
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
end

##### locale #####
if portuguese
  gsub_file "config/application.rb", "    # config.i18n.default_locale = :de", "    config.i18n.default_locale = 'pt-BR'"
end

##### gmail #####
if gmail
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
end

##### jquery #####
if jquery
  run "rm public/javascripts/*"
  get "http://code.jquery.com/jquery-1.4.2.min.js", "public/javascripts/jquery/jquery-1.4.2.min.js"
  get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"
end

##### clean #####
if clean
  run "rm README public/index.html public/images/rails.png doc/README_FOR_APP"
end

##### db #####
rake "db:create:all"
rake "db:migrate"
rake "db:test:prepare"

##### git #####
if sgit
  file ".gitignore", File.read("#{File.dirname(__FILE__)}/gitignore")
  git :init
  git :add => "."
  git :commit => "-am 'Initial commit'"
end
