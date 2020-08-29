require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full_title helper' do
    assert_equal full_title, "Mutter App"
    assert_equal full_title("Help"), "Help | Mutter App"
  end
end
