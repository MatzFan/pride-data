require 'sinatra'
require 'better_errors'
require 'mongo'
require 'json/ext' # required for .to_json

include Mongo

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

helpers do
  # a helper method to turn a string ID
  # representation into a BSON::ObjectId
  def object_id bson_string
    BSON::ObjectId.from_string(bson_string)
  end

  def doc_by_name doc_name
    settings.docs.find_one(name: doc_name).to_json
  end

  def doc_source doc_name
    JSON.parse(doc_by_name(doc_name))['source']
  end
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
