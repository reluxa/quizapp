$: << File.join(File.dirname(__FILE__), "/../lib")

require 'bundler/setup'  
Bundler.require(:default)

use Rack::Session::Pool

set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "views/auth/"

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def get_letter(i)
    return "a" if i==0
    return "b" if i==1
    return "c" if i==2
  end

end

require_relative 'models/init'
require_relative 'routes/init'


