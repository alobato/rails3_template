# Feature: Login

#   In order to access the system
#   As a user
#   I want to login

#   Scenario: Login with valid email and password
#     Given I don't have an account
#     And I am on the signup page
#     When I fill in "Email" with ...
#     And I fill in "Password"" with ...
#     And I press "Login"
#     Then I should be redirected to main page or origin page

#   Scenario: Login with invalid email and password
#   ...Then I should see "Error" message

require 'spec_helper'

describe 'Login' do
  
  before { visit '/login' }
  
  it "initial check" do
    page.should have_form_to('/login')
  end

  context 'with valid credentials' do
    before do
      user = Factory(:user)
      fill_in 'Email', :with => user.email
      fill_in 'Senha', :with => user.password
      click_button 'Login'
    end
    
    subject { page }
    it { should have_content('Login realizado com sucesso') }
    it { should_not have_form_to('/login') }
    it { should current_path_to('/') }
  end

  context 'with invalid credentials' do
    before do
      fill_in 'Email', :with => 'email.com'
      fill_in 'Senha', :with => '123'
      click_button 'Login'
    end

    subject { page }
    it { should have_content('Email e/ou senha inválidos') }
    it { should have_form_to('/login') }
    it { should current_path_to('/login') }
  end
  
end
