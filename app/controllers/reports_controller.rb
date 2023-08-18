# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :check_author, only: %i[edit update destroy]

  def index
    @reports = Report.all
  end

  def show
    @report = Report.find(params[:id])
    # user_id = @report.comments.pick(:user_id)
    # @comment_user = User.find(user_id)
  end

  def new
    @report = Report.new
  end

  def edit
    @report = Report.find(params[:id])
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id

    respond_to do |format|
      if @report.save
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  def check_author
    report = Report.find(params[:id])
    redirect_to reports_path unless report.user == current_user
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :content, :comment)
  end
end
