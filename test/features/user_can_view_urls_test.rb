require_relative '../test_helper'

class UserCanViewUrlsTest < FeatureTest

  def test_user_can_view_url_page
    create_payloads(1)
    visit '/sources/jumpstartlab0/urls/blog0'

    assert page.has_content?("Average")
  end

end
