# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    books_path # ログイン後に遷移するpathを設定
  end

  def after_sign_out_path_for(_)
    new_user_session_path # ログアウト後に遷移するpathを設定
  end
end
