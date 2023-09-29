# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '名前かメールを表示する' do
    alice = users(:alice)
    assert_equal 'alice', alice.name_or_email

    alice.name = ''
    assert_equal 'alice@example.com', alice.name_or_email
  end
end
