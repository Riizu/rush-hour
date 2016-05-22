require_relative '../test_helper'

class UserCanNavigateToClientFromEventTest < FeatureTest

  def test_user_can_view_client_page
    create_payloads(1)
    visit '/sources/jumpstartlab0/events/socialLogin0'

    click_link "Jumpstartlab"

    assert_equal '/sources/jumpstartlab0', current_path
  end

end
