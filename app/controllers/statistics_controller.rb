class StatisticsController < ApplicationController
  # /stats
  def index
    @scanned = Ticket.paid.where(:scanned => true).count
    @total   = Ticket.paid.count
    render 'statistics/index'
  end
end

