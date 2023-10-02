# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:alice_report)
    visit root_path
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました。' # CapybaraにTurbolinksの完了を待たせる
  end

  test 'ログイン後、日報の一覧ページが表示できるか' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'メールアドレスとパスワードでログインして日報を書く' do
    click_on '日報'
    click_on '日報の新規作成'
    fill_in 'タイトル', with: 'はじめての日報'
    fill_in '内容', with: '今日はminiテストについて学びました！'
    click_on '登録する'
    assert_text '日報が作成されました。'
    assert_text 'はじめての日報'
    assert_text '今日はminiテストについて学びました！'
  end

  test '日報の更新ができているか' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first
    fill_in 'タイトル', with: '日報を更新します！'
    fill_in '内容', with: '日報の更新完了！'
    click_on '更新する'
    assert_text '日報が更新されました。'
    assert_text '日報を更新します！'
    assert_text '日報の更新完了！'
  end

  test '日報が削除できているか' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first
    assert_text '日報が削除されました。'
  end
end
