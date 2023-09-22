# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :image do |attachable|
    attachable.variant :user_icon, resize_to_limit: [150, 150]
  end
end
