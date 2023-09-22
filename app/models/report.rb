# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_references,
           class_name: 'Mention',
           foreign_key: 'mentioning_report_id',
           inverse_of: :mentioning_report,
           dependent: :destroy

  has_many :mentioning_reports,
           through: :mentioning_references,
           source: :mentioned_report

  has_many :mentioned_references,
           class_name: 'Mention',
           foreign_key: 'mentioned_report_id',
           inverse_of: :mentioned_report,
           dependent: :destroy

  has_many :mentioned_reports,
           through: :mentioned_references,
           source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true
  validate do
    errors.add(:content, 'に存在しない言及先が含まれています') if exist_report?(content)
  end

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_with_mentions
    return false unless valid?

    transaction do
      save!
      update_mentions
    end
  end

  ID_REGEXP = %r{http://localhost:3000/reports/(\d+)}
  def update_mentions
    mentioning_references.destroy_all
    mention_ids = content.scan(ID_REGEXP).flatten.map(&:to_i).uniq
    mention_ids.each do |mention_id|
      Mention.create!(mentioning_report_id: id, mentioned_report_id: mention_id)
    end
  end

  def exist_report?(content)
    mention_ids = content.scan(ID_REGEXP).flatten.map(&:to_i).uniq
    Report.where(id: mention_ids).count != mention_ids.length
  end
end
