require 'pp'
require 'sinatra/base'
require 'feedjira'
require 'nokogiri'
require 'readability'
require 'json'
require 'slim'
require 'coffee_script'
require 'stylus'
require 'autoprefixer-rails'

require 'curb'

FEEDS = {
  'Wonderful blog' => 'http://transground.blogspot.com/feeds/posts/default'#,
  # 'Gamer' => 'http://www.gamer.no/feeds/general.xml'
}

class Unpress < Sinatra::Base
  set :views, root
  Slim::Engine.set_default_options format: :html5

  get '/' do
    slim ''
  end

  get '/feeds.json' do
    feeds.to_json
  end

  get %r{/url/(.+)} do
    url = params[:captures].first.gsub('http:/', 'http://')
    src = Curl.get(url).body_str
    content_type :json
    { content: Readability::Document.new(src).content }.to_json
  end

  def feeds
    feeds = Feedjira::Feed.fetch_and_parse FEEDS.values
    feeds.map do |url, feed|
      {
        url: url,
        entries: feed.entries.map { |entry| jsonify(entry) }
      }
    end
  end

  def jsonify(entry)
    {
      title: entry.title,
      url: entry.url,
      published: entry.published,
      preview: Nokogiri::HTML(entry.content).text
    }
  end

  get '/app.css' do
    content_type :css
    AutoprefixerRails.process(Stylus.compile files("app/**/*.styl")).css
  end

  get '/app.js' do
    content_type :js
    files("vendor/**/*.js") + coffee(files("app/**/*.coffee"))
  end

  def files(pattern)
    Dir[pattern].map { |file| IO.read(file) }.join("\n")
  end
end

