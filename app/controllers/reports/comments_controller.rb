# frozen_string_literal: true

class Reports::CommentsController < CommentsController
  before_action :set_commentable

  def create
    report = Report.find(params[:report_id])
    comment = report.comments.build(comment_params)
    comment.user = current_user
    comment.save!
    redirect_to report, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end
end
