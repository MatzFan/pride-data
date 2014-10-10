require 'sinatra'
require 'better_errors'
require 'mongo'
require 'json/ext' # required for .to_json
require_relative 'helpers'

include Mongo

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

configure do
  mongo_url = ENV['MONGOLAB_URI'] || 'mongodb://localhost:27017/pride-development'
  uri = URI.parse(mongo_url)
  db_name = uri.path.gsub('/', '')
  conn = MongoClient.from_uri(mongo_url)
  set :mongo_connection, conn
  set :mongo_db, conn.db(db_name)
  set :docs, Proc.new { mongo_db.collection('docs') } # proc needed here
end

configure do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do

end

get '/document/:name/?' do
  doc_source(params[:name])
end

get '/documents/?' do
  content_type :json
  settings.docs.find.to_a.to_json
end

post '/new_doc' do
  name = params[:name]
  source = params[:source]
  settings.docs.insert(name: name, source: source)
end
