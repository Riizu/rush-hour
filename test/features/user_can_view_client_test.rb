require_relative '../test_helper'

class UserCanViewClientTest < FeatureTest

  def test_user_can_view_client_page
    create_payloads(1)
    visit '/sources/jumpstartlab0'

    assert page.has_content?("Most Frequent Request Type:")
  end

end
