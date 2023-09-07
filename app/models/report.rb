# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mentions,
           class_name: 'Mention',
           foreign_key: 'mentioning_report_id',
           inverse_of: :mentioning_report,
           dependent: :destroy

  has_many :mentioning_reports,
           through: :active_mentions,
           source: :mentioned_report

  has_many :passive_mentions,
           class_name: 'Mention',
           foreign_key: 'mentioned_report_id',
           inverse_of: :mentioned_report,
           dependent: :destroy

  has_many :mentioned_reports,
           through: :passive_mentions,
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

  def report_mention_save
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      save!
      mention_create_or_update
    rescue ActiveRecord::RecordInvalid => e
      e.record
    end
  end

  def report_mention_update(params)
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      update!(params)
      mention_create_or_update
    rescue ActiveRecord::RecordInvalid => e
      e.record
    end
  end

  def mention_create_or_update
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
