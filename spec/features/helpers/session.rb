module SessionHelpers	

	def sign_up(username="Alice", email="alice@hotmail.com", password = "oranges!", password_confirmation = "oranges!")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		expect(page.status_code).to eq(200)
		fill_in :username, :with => username
		fill_in :email, :with => email
		fill_in :password, :with => password
		fill_in :password_confirmation, :with => password_confirmation
		click_button "Sign up"
	end

	def sign_in(email, password)
		visit '/sessions/new'
		fill_in 'email', :with => email
		fill_in 'password', :with => password
		click_button 'Sign in'
	end
end