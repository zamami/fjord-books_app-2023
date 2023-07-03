# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all
    @users = User.page(params[:page]).per(10).order(:created_at, :id)
  end

  def show
    @user = User.find(params[:id])
  end
end
