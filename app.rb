Encoding.default_external = "UTF-8"

require "cuba"
require "cuba/contrib"
require "mote"
require "ohm"
require "ohm/contrib"
require "rack/protection"

APP_SECRET = ENV.fetch("APP_SECRET")
OPENREDIS_URL = ENV.fetch("OPENREDIS_URL")

ROOT = File.expand_path("../", __FILE__)

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers

Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

Ohm.redis = Redic.new(OPENREDIS_URL)

Cuba.use Rack::Session::Cookie,
  key: "connect-four",
  secret: APP_SECRET

Cuba.use Rack::Protection, except: :http_origin
Cuba.use Rack::Protection::RemoteReferrer

Cuba.use Rack::Static,
  urls: %w[/js /css /img /fonts],
  root: File.expand_path("./public", __dir__)

Cuba.define do
  on default do
    run Guests
  end
end
