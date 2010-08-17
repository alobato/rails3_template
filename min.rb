gem "rspec-rails", "2.0.0.beta.19", :group => [:test, :development]
gem "cucumber-rails", "0.3.2", :group => [:test, :development]
gem "factory_girl_rails", "1.0", :group => :test
gem "remarkable_activerecord", "4.0.0.alpha4", :group => :test
gem "capybara", "0.3.9", :group => :test
gem "launchy", "0.3.7", :group => :test

gem "haml", "3.0.17"
gem "compass", "0.10.4"

gem "devise", "1.1.1"
gem "friendly_id", "3.1.3"
gem "will_paginate", "3.0.pre2"
gem "attribute_normalizer", "0.2.0"

run "bundle install"

generate "rspec:install"
# $ rails g rspec:install
#       create  .rspec
#       create  spec
#       create  spec/spec_helper.rb
#       create  autotest
#       create  autotest/discover.rb

generate "cucumber:install --rspec --capybara"
# $ rails g cucumber:install --rspec --capybara
#       create  config/cucumber.yml
#       create  script/cucumber
#        chmod  script/cucumber
#       create  features/step_definitions
#       create  features/step_definitions/web_steps.rb
#       create  features/support
#       create  features/support/paths.rb
#       create  features/support/env.rb
#        exist  lib/tasks
#       create  lib/tasks/cucumber.rake
#         gsub  config/database.yml
#         gsub  config/database.yml
#        force  config/database.yml

generate "devise:install"
# $ rails g devise:install
#       create  config/initializers/devise.rb
#       create  config/locales/devise.en.yml
# 
# ===============================================================================
# 
# Some setup you must do manually if you haven't yet:
# 
#   1. Setup default url options for your specific environment. Here is an
#      example of development environment:
# 
#        config.action_mailer.default_url_options = { :host => 'localhost:3000' }
# 
#      This is a required Rails configuration. In production it must be the
#      actual host of your application
# 
#   2. Ensure you have defined root_url to *something* in your config/routes.rb.
#      For example:
# 
#        root :to => "home#index"
# 
#   3. Ensure you have flash messages in app/views/layouts/application.html.erb.
#      For example:
# 
#        <p class="notice"><%= notice %></p>
#        <p class="alert"><%= alert %></p>
# 
# ===============================================================================

generate "devise:views"
# $ rails g devise:views
#       create  app/views/devise
#       create  app/views/devise/confirmations/new.html.erb
#       create  app/views/devise/mailer/confirmation_instructions.html.erb
#       create  app/views/devise/mailer/reset_password_instructions.html.erb
#       create  app/views/devise/mailer/unlock_instructions.html.erb
#       create  app/views/devise/passwords/edit.html.erb
#       create  app/views/devise/passwords/new.html.erb
#       create  app/views/devise/registrations/edit.html.erb
#       create  app/views/devise/registrations/new.html.erb
#       create  app/views/devise/sessions/new.html.erb
#       create  app/views/devise/shared/_links.erb
#       create  app/views/devise/unlocks/new.html.erb

gsub_file "config/environments/development.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\nend"
gsub_file "config/environments/test.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\nend"
gsub_file "config/environments/production.rb", /^end$/, "\n  config.action_mailer.default_url_options = { :host => 'site.com' }\nend"

generate "controller home index"
# $ rails g controller home index
#       create  app/controllers/home_controller.rb
#        route  get "home/index"
#       invoke  erb
#       create    app/views/home
#       create    app/views/home/index.html.erb
#       invoke  rspec
#       create    spec/controllers/home_controller_spec.rb
#       create    spec/views/home
#       create    spec/views/home/index.html.erb_spec.rb
#       invoke  helper
#       create    app/helpers/home_helper.rb
#       invoke    rspec
#       create      spec/helpers/home_helper_spec.rb

gsub_file "config/routes.rb", '  get "home/index"', ""
route "root :to => 'home#index'"
run "rm spec/controllers/home_controller_spec.rb"
run "rm -rf spec/views/home"
run "rm app/helpers/home_helper.rb"
run "rm spec/helpers/home_helper_spec.rb"

# $ rails g devise User
#       invoke  active_record
#       create    app/models/user.rb
#       invoke    rspec
#       create      spec/models/user_spec.rb
#       create    db/migrate/20100816203044_devise_create_users.rb
#       inject    app/models/user.rb
#        route  devise_for :users

get "http://gist.github.com/raw/527881/7db87caca84e557a6aead74b1608d0a2b999e988/user.rb", "app/models/user.rb"
get "http://gist.github.com/raw/527881/983fa358d8b2b78fbe70595722666e9ce1b9615a/devise_create_users.rb", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_devise_create_users.rb"
route "devise_for :users"
get "http://gist.github.com/raw/527881/1949bd809284f87f9f3d4c2f0f60132e047e01e3/devise.pt-BR.yml", "config/locales/devise.pt-BR.yml"

get "http://gist.github.com/raw/527881/c9268dfa577a4f25f5bba94a12cb29e72280f9fb/pt-BR.yml", "config/locales/pt-BR.yml"
gsub_file "config/application.rb", "    # config.i18n.default_locale = :de", "    config.i18n.default_locale = 'pt-BR'"

gsub_file "config/environments/development.rb", /^end$/, <<-END

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "gmail.com",
    :user_name            => "username@gmail.com",
    :password             => "your_password",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }

end

END

run "rm README public/index.html public/images/rails.png doc/README_FOR_APP"
file "README.md", "README"

get "http://code.jquery.com/jquery-1.4.2.min.js", "public/javascripts/jquery-1.4.2.min.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

rake "db:create:all"
rake "db:migrate"
rake "db:test:prepare"

file ".gitignore", <<-END
.bundle
db/*.sqlite3
log/*.log
tmp/**/*
vendor/rails/*
public/system/*
.DS_Store
db/schema.rb
public/cache
public/system
doc/*
cache
END
git :init
git :add => "."
git :commit => "-am 'Primeiro commit'"

# $ compass init rails .
# Compass recommends that you keep your stylesheets in app/stylesheets
#   instead of the Sass default location of public/stylesheets/sass.
#   Is this OK? (Y/n) Y
# 
# Compass recommends that you keep your compiled css in public/stylesheets/compiled/
#   instead the Sass default of public/stylesheets/.
#   However, if you're exclusively using Sass, then public/stylesheets/ is recommended.
#   Emit compiled stylesheets to public/stylesheets/compiled/? (Y/n) n
# directory ./app/stylesheets/
#    exists ./public/stylesheets
#    exists ./config
#    create ./config/compass.rb
#    exists ./config/initializers
#    create ./config/initializers/compass.rb
#   convert screen.sass
#    create ./app/stylesheets/screen.scss
#   convert print.sass
#    create ./app/stylesheets/print.scss
#   convert ie.sass
#    create ./app/stylesheets/ie.scss
# 
# Congratulations! Your rails project has been configured to use Compass.
# Just one more thing left to do: Register the compass gem.
# 
# In Rails 2.2 & 2.3, add the following to your evironment.rb:
# 
#   config.gem "compass", :version => ">= 0.10.2"
# 
# In Rails 3, add the following to your Gemfile:
# 
#   gem "compass", ">= 0.10.2"
# 
# Then, make sure you restart your server.
# 
# Sass will automatically compile your stylesheets during the next
# page request and keep them up to date when they change.
# 
# Next add these lines to the head of your layouts:
# 
# %head
#   = stylesheet_link_tag 'screen.css', :media => 'screen, projection'
#   = stylesheet_link_tag 'print.css', :media => 'print'
#   /[if IE]
#     = stylesheet_link_tag 'ie.css', :media => 'screen, projection'
# 
# (You are using haml, aren't you?)

get "http://gist.github.com/raw/527881/033d9ee44405ce178a50eb2083c805ba11db6264/_960.scss", "app/stylesheets/_960.scss"
get "http://gist.github.com/raw/527881/8b3db224d76e87052235488a78747c3fa46e7883/application.scss", "app/stylesheets/application.scss"
run "rm app/views/layouts/application.html.erb"
get "http://gist.github.com/raw/527881/80a7dc3fc7bf24b7d777586f2cd6a5ab9d2af0c5/application.html.haml", "app/views/layouts/application.html.haml"

gsub_file "config/routes.rb", /^end$/, <<-END

  devise_scope :user do
    get    "criar-conta",             :to => "devise/registrations#new", :as => :signup
    post   "criar-conta",             :to => "devise/registrations#create", :as => :signup
    get    "login",                   :to => "devise/sessions#new", :as => :login
    post   "login",                   :to => "devise/sessions#create", :as => :login
    get    "sair",                    :to => "devise/sessions#destroy", :as => :logout
    get    "recuperar-senha",         :to => "devise/passwords#new", :as => :recover_password
    post   "recuperar-senha",         :to => "devise/passwords#create", :as => :recover_password
    get    "s/:reset_password_token", :to => 'devise/passwords#edit', :as => :reset_password
    put    "alterar-senha",           :to => 'devise/passwords#update', :as => :change_password
    get    "enviar-confirmacao",      :to => "devise/confirmations#new", :as => :send_confirmation
    post   "enviar-confirmacao",      :to => "devise/confirmations#create", :as => :send_confirmation
    get    "c/:confirmation_token",   :to => "devise/confirmations#show", :as => :confirmation
    get    "editar-dados",            :to => "devise/registrations#edit", :as => :account
    put    "editar-dados",            :to => "devise/registrations#update", :as => :account
    delete "cancelar-conta",          :to => "devise/registrations#destroy", :as => :cancel_account
  end

end
END
