# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :body, presence: true
  belongs_to :commentable, polymorphic: true
  belongs_to :user, foreign_key: :user_id
end
