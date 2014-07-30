require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

feature "User signs up" do 
	scenario "when being logged out" do 
		expect(lambda { sign_up }).to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@hotmail.com")
		expect(User.first.email).to eq("alice@hotmail.com")
	end

	scenario "with a password that doesn't match" do 
		expect(lambda { sign_up('a@a.com', 'pass', 'wrong')}).to change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Password does not match the confirmation")
	end

	scenario "with an email that is already registred" do 
		expect(lambda { sign_up }).to change(User, :count).by(1)
		expect(lambda { sign_up }).to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end
end

feature "User signs in" do
	before(:each) do
		User.create(:email => "test@test.com",
								:password => 'test',
								:password_confirmation => 'test')
	end

	scenario "with correct credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'test')
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario "with incorrect credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'wrong')
		expect(page).not_to have_content("Welcome, test@test.com")
	end
end

feature 'User signs out' do
  before(:each) do
    User.create(:email => "test@test.com", 
                :password => 'test', 
                :password_confirmation => 'test')
  end

  scenario 'while being signed in' do
    sign_in('test@test.com', 'test')
    click_button "Sign out"
    expect(page).to have_content("Good bye!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end
end

feature 'User requests password reset' do
	before(:each) do
    User.create(:email => "test@test.com", 
                :password => 'test', 
                :password_confirmation => 'test')
  end

  scenario 'when requesting reset' do
  	visit '/sessions/new'
  	fill_in 'forgot_email', :with => "test@test.com"
  	expect(Messaging).to receive(:send_email).with(User.first)
  	click_button "Reset password"
  	expect(page).to have_content("Password reset email sent")

  	token = User.first.password_token
  	visit "/users/reset_password/#{token}"
  	fill_in 'password', :with => "dog"
  	fill_in 'password_confirmation', :with => "dog"
  	click_button "Confirm"
  	expect(User.first.password_token).to be nil
  end
end
