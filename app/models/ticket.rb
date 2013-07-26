class Ticket < ActiveRecord::Base
  belongs_to :order
  belongs_to :ticket_type

  # HACK: See models/order.rb for the full explanation.
  default_scope where('tickets.created_at > ?', "#{Time.now.year}-01-01")

  scope :paid, joins(:order).where(:orders => {:status => Order::RESOLVED})
  scope :unpaid, joins(:order).where(:orders => {:status => Order::PAYMENT_PENDING})

  def scanned?
    scans.length > 0
  end

  def scans
    @scans ||= Scan.find_all_by_ticket_code(code)
  end

  def scan!
    Scan.create(
      :order_id => order.id,
      :ticket_id => id,
      :order_code => order.code,
      :ticket_code => code,
      :booth => HostHelpers::id || "Unknown"
    )
    self.scanned = true
    save!
  end

  class << self

    def code?(code)
      code.match /\A#{Barcode::TICKET_REGEX_PARTS}\z/
    end

  end
end
