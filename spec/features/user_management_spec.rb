require 'spec_helper'

feature "User signs up" do 

	scenario "when being logged out" do 
		expect(lambda { sign_up }).to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@hotmail.com")
		expect(User.first.email).to eq("alice@hotmail.com")
	end

	def sign_up(email="alice@hotmail.com", password = "oranges!")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		expect(page.status_code).to eq(200)
		fill_in :email, :with => email
		fill_in :password, :with => password
		click_button "Sign up"
	end
end