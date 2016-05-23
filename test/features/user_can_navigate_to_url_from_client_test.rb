require_relative '../test_helper'

class UserCanNavigateToUrlFromClientTest < FeatureTest

  def test_user_can_view_client_page
    create_payloads(1)
    visit '/sources/jumpstartlab0'

    click_link "/blog0"

    assert_equal '/sources/jumpstartlab0/urls/blog0', current_path
  end

end
