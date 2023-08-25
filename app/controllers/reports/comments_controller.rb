# frozen_string_literal: true

class Reports::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

  def render_commentable
    @report = @commentable
    flash.now[:alert] = @comment.errors.full_messages_for(:body).first
    @alert = flash.now[:alert]
    render 'reports/show', alert: @alert
  end
end
