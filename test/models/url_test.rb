require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  def test_it_can_pull_associated_verbs
    assert_equal ["GET"], url.associated_verbs
  end

  def test_it_can_pull_three_most_popular_referrers
    id_1 = Referrer.create({:name => "http://jumpstartlab.com/test1"})
    id_2 = Referrer.create({:name => "http://jumpstartlab.com/test2"})
    id_3 = Referrer.create({:name => "http://jumpstartlab.com/test3"})

    PayloadRequest.create({
      :url_id => url.id,
      :referrer_id => id_1.id,
      :request_type_id => request_type.id,
      :requested_at => "2013-02-16 21:38:28 -0700",
      :event_name_id => event_name.id,
      :user_agent_id => user_agent.id,
      :responded_in => 37,
      :parameters => [],
      :ip_id => ip.id,
      :resolution_id => resolution.id
      })

    PayloadRequest.create({
      :url_id => url.id,
      :referrer_id => id_2.id,
      :request_type_id => request_type.id,
      :requested_at => "2013-02-16 21:38:28 -0700",
      :event_name_id => event_name.id,
      :user_agent_id => user_agent.id,
      :responded_in => 37,
      :parameters => [],
      :ip_id => ip.id,
      :resolution_id => resolution.id
      })

    PayloadRequest.create({
      :url_id => url.id,
      :referrer_id => id_2.id,
      :request_type_id => request_type.id,
      :requested_at => "2013-02-16 21:38:28 -0700",
      :event_name_id => event_name.id,
      :user_agent_id => user_agent.id,
      :responded_in => 37,
      :parameters => [],
      :ip_id => ip.id,
      :resolution_id => resolution.id
      })

    PayloadRequest.create({
      :url_id => url.id,
      :referrer_id => id_3.id,
      :request_type_id => request_type.id,
      :requested_at => "2013-02-16 21:38:28 -0700",
      :event_name_id => event_name.id,
      :user_agent_id => user_agent.id,
      :responded_in => 37,
      :parameters => [],
      :ip_id => ip.id,
      :resolution_id => resolution.id
      })

    assert_equal [], url.top_three_referrers
  end

  def test_it_finds_max_response_time_for_url_with_one_request
    assert_equal 37, url.max_response_time
  end

  def test_it_finds_max_response_time_for_url_with_multiple_requests
    payload2 = PayloadRequest.create({
      :url_id => url.id,
      :referrer_id => referrer.id,
      :request_type_id => request_type.id,
      :requested_at => "2013-02-16 21:38:28 -0700",
      :event_name_id => event_name.id,
      :user_agent_id => user_agent.id,
      :responded_in => 40,
      :parameters => [],
      :ip_id => ip.id,
      :resolution_id => resolution.id
      })

      payload3 = PayloadRequest.create({
        :url_id => url.id,
        :referrer_id => referrer.id,
        :request_type_id => request_type.id,
        :requested_at => "2013-02-16 21:38:28 -0700",
        :event_name_id => event_name.id,
        :user_agent_id => user_agent.id,
        :responded_in => 45,
        :parameters => [],
        :ip_id => ip.id,
        :resolution_id => resolution.id
        })
    assert_equal 45, url.max_response_time
  end

  def test_it_finds_min_response_time_for_url_with_one_request
    assert_equal 37, url.min_response_time
  end

  def test_it_finds_max_response_time_for_url_with_two_requests
    payload2 = PayloadRequest.create({
      :url_id => url.id,
      :referrer_id => referrer.id,
      :request_type_id => request_type.id,
      :requested_at => "2013-02-16 21:38:28 -0700",
      :event_name_id => event_name.id,
      :user_agent_id => user_agent.id,
      :responded_in => 35,
      :parameters => [],
      :ip_id => ip.id,
      :resolution_id => resolution.id
      })

      payload3 = PayloadRequest.create({
        :url_id => url.id,
        :referrer_id => referrer.id,
        :request_type_id => request_type.id,
        :requested_at => "2013-02-16 21:38:28 -0700",
        :event_name_id => event_name.id,
        :user_agent_id => user_agent.id,
        :responded_in => 45,
        :parameters => [],
        :ip_id => ip.id,
        :resolution_id => resolution.id
        })

    assert_equal 35, url.min_response_time
  end

  def test_it_finds_response_times_longest_to_shortest
    payload2 = PayloadRequest.create({
      :url_id => url.id,
      :referrer_id => referrer.id,
      :request_type_id => request_type.id,
      :requested_at => "2013-02-16 21:38:28 -0700",
      :event_name_id => event_name.id,
      :user_agent_id => user_agent.id,
      :responded_in => 35,
      :parameters => [],
      :ip_id => ip.id,
      :resolution_id => resolution.id
      })
    assert_equal [37, 35], url.response_times_longest_to_shortest
  end

  def test_it_finds_average_response_time_for_url_with_one_request
    assert_equal 37, url.average_response_time
  end

  def test_it_finds_average_response_time_for_url_with_multiple_requests
    payload2 = PayloadRequest.create({
      :url_id => url.id,
      :referrer_id => referrer.id,
      :request_type_id => request_type.id,
      :requested_at => "2013-02-16 21:38:28 -0700",
      :event_name_id => event_name.id,
      :user_agent_id => user_agent.id,
      :responded_in => 35,
      :parameters => [],
      :ip_id => ip.id,
      :resolution_id => resolution.id
      })

      payload3 = PayloadRequest.create({
        :url_id => url.id,
        :referrer_id => referrer.id,
        :request_type_id => request_type.id,
        :requested_at => "2013-02-16 21:38:28 -0700",
        :event_name_id => event_name.id,
        :user_agent_id => user_agent.id,
        :responded_in => 45,
        :parameters => [],
        :ip_id => ip.id,
        :resolution_id => resolution.id
        })

    assert_equal 39, url.average_response_time
  end
end
