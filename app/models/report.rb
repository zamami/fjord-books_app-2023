# frozen_string_literal: true

class Report < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  def created_by?(current_user)
    user == current_user
  end
end
