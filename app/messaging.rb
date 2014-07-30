class Messaging

	API_KEY = ENV['MAILGUN_API_KEY']
	API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/postmaster@app27923148.mailgun.org"
	
	def self.send_email(user)
		# link = "http://radiant-refuge-8401.herokuapp.com/users/reset_password/#{user.password_token}"
		link = "localhost:9292/users/reset_password/#{user.password_token}"
	  
	  RestClient.post "https://api:#{API_KEY}"\
	  "@api.mailgun.net/v2/app27923148.mailgun.org/messages",
	  :from => "Dave and Michiel <me@app27923148.mailgun.org>",
	  :to => user.email,
	  :subject => "Password reset",
	  :text => "Here is the link: http://#{link}"
	end
end