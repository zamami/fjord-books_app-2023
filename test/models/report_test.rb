# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'レポートを書いたユーザーかどうか？' do
    alice = users(:alice)
    bob = users(:bob)
    alice_report = reports(:alice_report)
    assert alice_report.editable?(alice)
    assert_not alice_report.editable?(bob)
  end

  test 'レポートが作られた日付が正しいか確認' do
    alice_report = reports(:alice_report)
    today = Time.zone.today
    assert_equal today, alice_report.created_on
  end

  test 'メンションしているか、されているか？' do
    alice_report = reports(:alice_report)
    bob_report = reports(:bob_report)
    assert_not_includes alice_report.mentioning_reports, bob_report
    assert_not_includes bob_report.mentioned_reports, alice_report
    alice_report.mentioning_reports.push bob_report
    assert_includes alice_report.mentioning_reports, bob_report
    assert_includes bob_report.mentioned_reports, alice_report
  end
end
