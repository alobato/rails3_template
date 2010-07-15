# Feature: Sign up
#
#   In order to use the system
#   As a user without account
#   I want to create an account
#
#   Scenario: Sign up with valid email and password
#     Given I don't have an account
#     And I am on the signup page
#     When I fill in "Email" with ...
#     And I fill in "Password"" with ...
#     And I fill in "Password Confirmation" with ...
#     And I press "Sign up"
#     Then I should see "Successful sign up" message
#     And I should see logged in email
#     And I should receive a confirmation email
#
#   Scenario: Sign up with invalid email and password
#   ...Then I should see "Error" message
#
#   Scenario: Sign up with existent email
#   ...Then I should see "Email existent" message

require 'spec_helper'

describe 'Sign up' do
  
  before { visit '/criar-conta' }
  
  it "initial check" do
    page.should have_form_to('/criar-conta')
  end

  shared_examples_for 'signup_page' do
    it 'should be on sign up page' do
      subject.should current_path_to('/criar-conta')
      subject.should have_form_to('/criar-conta')
    end
  end

  context 'with valid credentials' do
    before do
      fill_in 'Email', :with => 'email@email.com'
      fill_in 'Senha', :with => '123456'
      fill_in 'Repita a senha', :with => '123456'
      click_button 'Criar conta'
    end
    
    subject { page }
    it { should have_content('Sua conta foi criada com sucesso. Foi enviado para seu email instruções de como confirmar sua conta.') }    
    it { should current_path_to('/') }
    it { should_not have_form_to('/criar-conta') }
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
    it_should_behave_like 'signup_page'
  end
  
  context 'with existent email' do
    before do
      user = Factory(:user)
      fill_in 'Email', :with => user.email
      fill_in 'Senha', :with => '123456'
      fill_in 'Repita a senha', :with => '123456'
      click_button 'Criar conta'
    end
    
    subject { page }
    it { should have_content('Email já está em uso') }
    it_should_behave_like 'signup_page'
  end

end
