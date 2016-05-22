require_relative '../test_helper'

class UserCanViewEventPageTest < FeatureTest

  def test_user_can_view_event_page
    create_payloads(1)
    visit '/sources/jumpstartlab0/events/socialLogin0'

    assert page.has_content?("Number of Events")
  end

end
