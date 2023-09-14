# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email' do
    alice = users(:Alice)
    assert_equal 'alice', alice.name_or_email

    alice.name = ''
    assert_equal 'alice@example.com', alice.name_or_email
  end
end
