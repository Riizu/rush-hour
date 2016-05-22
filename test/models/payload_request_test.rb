require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def test_it_creates_a_payload_request_with_valid_attributes
    create_payloads(1)
    payload = PayloadRequest.find(1)

    assert_equal "http://jumpstartlab.com/blog0", payload.url.name
    assert_equal "http://jumpstartlab.com0", payload.referrer.name
    assert_equal "GET 0", payload.request_type.verb
    assert_equal "socialLogin0", payload.event_name.name
    assert_equal "Mozilla 0", payload.user_agent.browser
    assert_equal "Macintosh 0", payload.user_agent.platform
    assert_equal "1920 0", payload.resolution.width
    assert_equal "1280 0", payload.resolution.height
    assert_equal 0, payload.responded_in.time
    assert_equal "63.29.38.210", payload.ip.value
  end
end
