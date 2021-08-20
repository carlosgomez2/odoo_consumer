class DashboardController < ApplicationController
  def index
    @income_by_day = Invoice.pluck(:invoice_date, :amount_total_signed)
    @best_partners = Invoice.group(:partner_name).order(:asc).sum(:amount_total_signed)
  end
end
