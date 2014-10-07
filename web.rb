require 'sinatra'
require 'mongo'

include Mongo

configure do
  mongo_url = ENV['MONGOLAB_URI'] || 'mongodb://localhost:27017/pride-development'
  uri = URI.parse(mongo_url)
  db_name = uri.path.gsub('/', '')
  conn = MongoClient.from_uri(mongo_url)
  set :mongo_connection, conn
  set :mongo_db, conn.db(db_name)
end

get '/' do
  settings.mongo_db.name
end
