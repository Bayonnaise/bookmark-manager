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

post '/users/reset_password' do
	email = params[:email]
	user = User.first(:email => email)
	password_token = (1..64).map{('A'..'Z').to_a.sample}.join
	password_token_timestamp = Time.now
	user.update(:password_token => password_token, :password_token_timestamp => password_token_timestamp)

	send_email(user)
	flash[:notice] = "Password reset email sent"
	redirect to('/')
end

get "/users/reset_password/:token" do
	token = params[:token]
	@user = User.first(:password_token => token)
	erb :"users/reset_password"
end

API_KEY = ENV['MAILGUN_API_KEY']
API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/postmaster@app27923148.mailgun.org"

def send_email(user)
	link = "http://radiant-refuge-8401.herokuapp.com/users/reset_password/#{user.password_token}"
  RestClient.post "https://api:#{API_KEY}"\
  "@api.mailgun.net/v2/app27923148.mailgun.org/messages",
  :from => "Dave and Michiel <me@app27923148.mailgun.org>",
  :to => user.email,
  :subject => "Password reset",
  :text => "Here is the link: http://#{link}"
end

