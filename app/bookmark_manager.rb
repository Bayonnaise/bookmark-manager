require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'
require 'rest_client'

require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'

require_relative 'helpers/application'
require_relative 'data_mapper_setup'

require_relative 'controllers/application'
require_relative 'controllers/users'
require_relative 'controllers/tags'
require_relative 'controllers/sessions'
require_relative 'controllers/links'



set :views, './app/views'
enable :sessions
set :session_secret, 'super secret'
set :partial_template_engine, :erb

use Rack::Flash
use Rack::MethodOverride

helpers MyHelpers





