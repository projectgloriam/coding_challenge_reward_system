require "test_helper"

class InvitesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get invites_new_url
    assert_response :success
  end
end
