require 'sinatra/base'
require 'haml'

module Smesser
  class Server < Sinatra::Base
    configure do
      set :root, "#{root}/server"
    end

    get '/' do
      redirect to('/index.html'), 301
    end

    get '/index.html' do
      haml :index
    end
  end
end
