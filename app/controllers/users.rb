get '/users/new' do
  @user = User.new
	erb :"users/new"
end

post '/users' do
	@user = User.create(:email => params[:email], :password => params[:password], 
    :password_confirmation => params[:password_confirmation])
  if @user.save
  	session[:user_id] = @user.id
  	redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

post '/users/reset_password/' do
	email = params[:email]
	user = User.first(:email => email)
	user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
	user.password_token_timestamp = Time.now
	user.save
	send_email(user)
end

get '/users/reset_password/:token' do
	user = User.first(:password_token => token)


end

API_KEY = ENV['MAILGUN_API_KEY']
API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/postmaster@app27923148.mailgun.org"

def send_email(user)
  RestClient.post API_URL+"/messages"

  :from => "Dave and Michiel <me@samples.mailgun.org>",
  :to => user.email,
  :subject => "Password reset",
  :text => <a href="localhost:9292/users/reset_password/#{user.password_token}">Click here to reset your password.</a>
end

