require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'
require './lib/link.rb'
require './lib/tag.rb'
require './lib/user.rb'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base
	set :views, './app/views'
	enable :sessions
	set :session_secret, 'super secret'
  use Rack::Flash

  helpers MyHelpers

  get '/' do
    @links = Link.all
  	erb :index
  end

  post '/links' do 
  	url = params["url"]
  	title = params["title"]
  	tags = params["tags"].split(" ").map do |tag|
  		Tag.first_or_create(:text => tag)
  	end
  	Link.create(:url => url, :title => title, :tags => tags)
  	redirect to ('/')
  end

  get '/tags/:text' do
  	tag = Tag.first(:text => params[:text])
  	@links = tag ? tag.links : []
  	erb :index
  end

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

  # start the server if ruby file executed directly
  run! if app_file == $0
end