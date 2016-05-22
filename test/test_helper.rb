ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'database_cleaner'
require 'rack/test'


Capybara.app = RushHour::Server

DatabaseCleaner.strategy = :truncation, {except: %w([public.schema_migrations])}

module TestHelpers
  include Rack::Test::Methods

  def app
    RushHour::Server
  end

  def setup
    DatabaseCleaner.start
  end

  def create_payloads(number)
    number.times do |i|

      url = Url.find_or_create_by({:name=> "http://jumpstartlab.com/blog#{i}"})
      referrer = Referrer.find_or_create_by({:name => "http://jumpstartlab.com#{i}"})
      request_type = RequestType.find_or_create_by({:verb => "GET #{i}"})
      requested_at = RequestedAt.find_or_create_by({time: "2013-02-16 21:38:28 -070#{i}"})
      event_name = EventName.find_or_create_by({:name => "socialLogin#{i}"})
      user_agent = PayloadUserAgent.find_or_create_by({:browser => "Mozilla #{i}", :platform => "Macintosh #{i}"})
      responded_in = RespondedIn.find_or_create_by({time: i})
      parameter = Parameter.find_or_create_by({list: "#{i}"})
      resolution = Resolution.find_or_create_by({:width => "1920 #{i}", :height => "1280 #{i}"})
      ip = Ip.find_or_create_by({:value => "63.29.38.21#{i}"})
      client = Client.find_or_create_by({:identifier => "jumpstartlab#{i}", :root_url => "http://jumpstartlab.com#{i}"})

      PayloadRequest.find_or_create_by({
        :url => url,
        :referrer => referrer,
        :request_type => request_type,
        :requested_at => requested_at,
        :event_name => event_name,
        :user_agent => user_agent,
        :responded_in => responded_in,
        :parameter => parameter,
        :ip => ip,
        :resolution => resolution,
        :client => client })
    end
  end

  def teardown
    DatabaseCleaner.clean
  end
end

Capybara.app = RushHour::Server

class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
