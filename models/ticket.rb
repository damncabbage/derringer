class Ticket < ActiveRecord::Base
  belongs_to :order

  default_scope where("tickets.created_at > '#{Time.now.year}-01-01'") # That sum hack.

  scope :paid, joins(:order).where(:orders => {:status => "resolved"})
  scope :unpaid, joins(:order).where(:orders => {:status => "payment_pending"})

  def scanned?
    scanned.length > 0
  end

  def scanned(code)
    @scans ||= Scan.find_all_by_ticket_code(code)
  end


  class << self

    def code?(code)
      code.match /\A#{Barcode::TICKET_REGEX_PARTS}\z/
    end

  end
end
