# Feature: Sign up

#   In order to access the system
#   As a user
#   I want to create an account

#   Scenario: Signup with valid email and password
#     Given I don't have an account
#     And I am on the signup page
#     When I fill in "Email" with ...
#     And I fill in "Password"" with ...
#     And I fill in "Password Confirmation" with ...
#     And I press "Criar conta"
#     Then I should see "Sua conta foi criada com sucesso"

require 'spec_helper'

describe 'Sign up' do
  
  before { visit '/criar-conta' }
  
  context 'with valid credentials' do
    before do
      fill_in 'Email', :with => 'email@email.com'
      fill_in 'Senha', :with => '123456'
      fill_in 'Repita a senha', :with => '123456'
      click_button 'Criar conta'
    end
    
    subject { page }
    
    it { should have_content('Sua conta foi criada com sucesso. Foi enviado para seu email instruções de como confirmar sua conta.') }
    it { should_not have_xpath('//form[@action="/criar-conta"]') }
    it { subject.current_path.should eql('/') }
  end

  context 'with invalid credentials' do
    before do
      fill_in 'Email', :with => 'email'
      fill_in 'Senha', :with => '123'
      fill_in 'Repita a senha', :with => '123'
      click_button 'Criar conta'
    end
    
    subject { page }
    
    it { should have_content('Email não é válido') }
    it { should have_content('Senha é muito curto(a)') }
    it { should have_xpath('//form[@action="/criar-conta"]') }
    it { subject.current_path.should eql('/criar-conta') }
  end
  
end
