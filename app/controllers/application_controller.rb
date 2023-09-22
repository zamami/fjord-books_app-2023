# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    books_path # ログイン後に遷移するpathを設定
  end

  def after_sign_out_path_for(_)
    new_user_session_path # ログアウト後に遷移するpathを設定
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name zip address profile])
  end
end
