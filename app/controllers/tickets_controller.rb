class TicketsController < ApplicationController
  respond_to :html

  # /tickets/:id
  def show
    @ticket = Ticket.includes(:order).find(params[:id])
    @order = @ticket.order
    respond_with(@ticket)
  end

  # /tickets/:id/scan
  def scan
    @ticket = Ticket.find(params[:id])
    @ticket.scan!
    flash[:scanned] = [@ticket.full_name]
    redirect_to root_url
  end

end
