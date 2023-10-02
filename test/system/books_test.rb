# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:test_book)
    visit root_path
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました。' # CapybaraにTurbolinksの完了を待たせる
  end

  test 'ログイン後、本の一覧ページが表示できるか' do
    visit books_url
    assert_selector 'h1', text: '本の一覧'
  end

  test 'メールアドレスとパスワードでログインして本を登録する' do
    click_on '本'
    click_on '本の新規作成'
    fill_in 'タイトル', with: 'TDD'
    fill_in 'メモ', with: 'テスト駆動開発'
    fill_in '著者', with: '和田卓人（翻訳)'
    click_on '登録する'
    assert_text '本が作成されました。'
    assert_text 'TDD'
    assert_text 'テスト駆動開発'
    assert_text '和田卓人（翻訳)'
  end

  test '本の更新ができているか' do
    visit book_url(@book)
    click_on 'この本を編集', match: :first
    fill_in 'タイトル', with: 'TDD駆動'
    fill_in 'メモ', with: 'すごくためになった！'
    fill_in '著者', with: 'Kent Beck (著)/和田卓人（翻訳)'
    click_on '更新する'
    assert_text 'TDD駆動'
    assert_text 'すごくためになった！'
    assert_text 'Kent Beck (著)/和田卓人（翻訳)'
  end

  test '本が削除できているか' do
    visit book_url(@book)
    click_on 'この本を削除', match: :first
    assert_text '本が削除されました。'
  end
end
