require 'bcrypt'

class User

	attr_reader :password
	attr_accessor :password_confirmation

	include DataMapper::Resource

	validates_confirmation_of :password
	validates_format_of :email, :as => :email_address
	# validates_uniqueness_of :email

	property :id, Serial
	property :username, String, :unique => true, :message => "This username is already taken"
	property :email, String, :unique => true, :message => "This email is already taken", :required => true
	property :password_digest, Text
	property :password_token, String, :length => 64 
	property :password_token_timestamp, Time


	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(:email => email)

		if user && BCrypt::Password.new(user.password_digest) == password
			 user
		else
			nil
		end
	end

end