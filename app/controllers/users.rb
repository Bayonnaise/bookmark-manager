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

		# <a href="localhost:9292/users/reset_password/#{token}">Reset password</a>
		# erb :"users/reset_password/:token"
	end

	get '/users/reset_password/:token' do
		user = User.first(:password_token => token)
	end
