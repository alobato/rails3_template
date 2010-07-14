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

require 'spec_helper'

describe 'Login' do
  
  let(:user) { Factory(:user) }
  
  before { visit '/login' }
  
  context 'with valid credentials' do
    before do
      fill_in 'Email', :with => user.email
      fill_in 'Senha', :with => user.password
      click_button 'Login'
    end
    
    subject { page }

    it { should have_content('Login realizado com sucesso') }
    it { should_not have_xpath('//form[@action="/login"]') }
    it { subject.current_path.should eql('/') }
  end

  context 'with invalid credentials' do
    before do
      fill_in 'Email', :with => 'email.com'
      fill_in 'Senha', :with => '123'
      click_button 'Login'
    end

    subject { page }

    it { should have_content('Email e/ou senha inválidos') }
    it { should have_xpath('//form[@action="/login"]') }
    it { subject.current_path.should eql('/login') }
  end
  
end
