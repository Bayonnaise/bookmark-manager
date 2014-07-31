class Link
	include DataMapper::Resource

	property :id,						Serial
	property :title,				String, :required => true
	property :url,					String, :required => true
	property :description, 	String, :required => false

	has n, :tags, :through => Resource

end