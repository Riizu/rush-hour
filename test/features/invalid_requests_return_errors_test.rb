require_relative '../test_helper'

class InvalidRequestsReturnErrorsTest < FeatureTest

  def test_invalid_requests_return_errors
    visit "/failed"

    assert page.has_content?("Error")
  end

end
