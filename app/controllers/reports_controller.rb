class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :check_author, only: %i[edit update destroy]

  # GET /reports or /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1 or /reports/1.json
  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports or /reports.json
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

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1 or /reports/1.json
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
    params.require(:report).permit(:title, :content)
  end
end
