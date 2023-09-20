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
    ActiveRecord::Base.transaction do
      save!
      update_mentions
    rescue ActiveRecord::RecordInvalid => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
      true if e.nil?
    end
  end

  def update_mentions
    already_mentioned_reports = mentioning_report_ids.empty? ? [] : [id].product(mentioning_report_ids)
    mention_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i).uniq
    now_mention_reports = mention_ids.empty? ? [] : mention_ids.map { |mention_id| [id, mention_id] }
    delete_mentions = already_mentioned_reports - now_mention_reports
    delete_mentions.each do |array|
      Mention.where(mentioning_report_id: array[0], mentioned_report_id: array[1]).find_each(&:destroy!)
    end
    create_mentions = now_mention_reports - already_mentioned_reports
    create_mentions.each do |array|
      Mention.create!(mentioning_report_id: array[0], mentioned_report_id: array[1])
    end
  end

  def exist_report?(content)
    mention_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i).uniq
    mention_ids.map { |mention_id| Report.exists?(id: mention_id) }.include?(false)
  end
end
