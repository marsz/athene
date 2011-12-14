class ReportsController < ApplicationController
  include ActAsReport
  
  def index
    @date = params[:date] || Time.now.to_date
    @report = daily_by_date(@date)
  end
end
