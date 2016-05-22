require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  def test_it_can_pull_associated_verbs
    create_payloads(1)
    url = Url.find(1)

    assert_equal ["GET 0"], url.associated_verbs.keys
  end

  def test_it_can_pull_three_most_popular_referrers
    create_payloads(1)
    url = Url.find(1)

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.find(1),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.find(1),
        :responded_in => RespondedIn.find(1),
        :parameter => Parameter.find(1),
        :ip => Ip.create(value: "127.0.0.1"),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.create(name: "http://test.com"),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.find(1),
        :responded_in => RespondedIn.find(1),
        :parameter => Parameter.find(1),
        :ip => Ip.find(1),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })


    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.create(name: "http://test.com1"),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.find(1),
        :responded_in => RespondedIn.find(1),
        :parameter => Parameter.find(1),
        :ip => Ip.find(1),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })

    assert_equal 3, url.top_three_referrers.length
    assert_equal "http://jumpstartlab.com0", url.top_three_referrers[0].name
  end

  def test_it_can_pull_three_most_popular_user_agents
    create_payloads(1)
    url = Url.find(1)

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.find(1),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.find(1),
        :responded_in => RespondedIn.find(1),
        :parameter => Parameter.find(1),
        :ip => Ip.create(value: "127.0.0.1"),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.find(1),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.create(browser: "test", platform: "test1"),
        :responded_in => RespondedIn.find(1),
        :parameter => Parameter.find(1),
        :ip => Ip.find(1),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.find(1),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.create(browser: "test1", platform: "test2"),
        :responded_in => RespondedIn.find(1),
        :parameter => Parameter.find(1),
        :ip => Ip.find(1),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })

    assert_equal 3, url.top_three_user_agents.length
    assert_equal "Mozilla 0", url.top_three_user_agents[0].browser
    assert_equal "Macintosh 0", url.top_three_user_agents[0].platform

  end

  def test_it_finds_max_response_time_for_url_with_multiple_requests
    create_payloads(1)
    url = Url.find(1)

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.find(1),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.find(1),
        :responded_in => RespondedIn.create(time: 37),
        :parameter => Parameter.find(1),
        :ip => Ip.create(value: "127.0.0.1"),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })

    assert_equal 37, url.max_response_time
  end

  def test_it_finds_min_response_time_for_url_with_multiple_requests
    create_payloads(1)
    url = Url.find(1)

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.find(1),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.find(1),
        :responded_in => RespondedIn.create(time: 37),
        :parameter => Parameter.find(1),
        :ip => Ip.create(value: "127.0.0.1"),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })
    assert_equal 0, url.min_response_time
  end

  def test_it_finds_response_times_longest_to_shortest
    create_payloads(1)
    url = Url.find(1)

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.find(1),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.find(1),
        :responded_in => RespondedIn.create(time: 37),
        :parameter => Parameter.find(1),
        :ip => Ip.create(value: "127.0.0.1"),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })

    assert_equal [37, 0], url.response_times_longest_to_shortest
  end

  def test_it_finds_average_response_time_for_url_with_multiple_requests
    create_payloads(1)
    url = Url.find(1)

    PayloadRequest.find_or_create_by({
        :url => Url.find(1),
        :referrer => Referrer.find(1),
        :request_type => RequestType.find(1),
        :requested_at => RequestedAt.find(1),
        :event_name => EventName.find(1),
        :user_agent => PayloadUserAgent.find(1),
        :responded_in => RespondedIn.create(time: 37),
        :parameter => Parameter.find(1),
        :ip => Ip.create(value: "127.0.0.1"),
        :resolution => Resolution.find(1),
        :client => Client.find(1) })

    assert_equal 19, url.average_response_time
  end
end
