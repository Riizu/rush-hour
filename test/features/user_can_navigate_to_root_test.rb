require_relative '../test_helper'

class UserCanNavigateToRootTest < FeatureTest

  def test_user_can_view_client_page
    create_payloads(1)
    visit '/sources/jumpstartlab0'

    click_link "Rush Hour Web Statistics"

    assert_equal '/', current_path
  end

end
