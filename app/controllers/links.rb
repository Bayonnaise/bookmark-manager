post '/links' do 
	url = params["url"]
	title = params["title"]
	description = params["description"]
	tags = params["tags"].split(" ").map do |tag|
		Tag.first_or_create(:text => tag)
	end

	if Link.first(:url => url) != nil 
		@link = Link.first(:url => url)
		@link.update(:url => url, :title => title, :tags => tags, :description => description)
	else
		Link.create(:url => url, :title => title, :tags => tags, :description => description)
	end
	redirect to ('/')
end

get '/links/new' do
	@link = Link.new
	erb :"links/new"
end

get '/links/edit/:id' do |id|
	@link = Link.first(:id => id)
	erb :"links/new"
end

get '/links/delete/:id' do |id|
	@link = Link.first(:id => id)
	flash[:notice] = "#{@link.title} deleted."
	@link.destroy!
	redirect to ('/')
end