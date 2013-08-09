class Order < ActiveRecord::Base

  RESOLVED = 'resolved'
  PAYMENT_PENDING = 'payment_pending'

  has_many :tickets

  # HACK: This is a terrible.
  # By way of context: the existing PHP-based system the data is imported
  # from doesn't separate orders by event (eg. SMASH! 2011, SMASH! 2012), instead relying
  # on the fact that there's an eight month gap between sale periods.
  # (Its replacement, Booth, handles this by having an Order's line items be associated with a
  # product belonging to a particular event; each year has a new set of ticket products.)
  default_scope where('orders.created_at > ?', "#{Time.now.year}-01-01")

  scope :paid, where(:status => RESOLVED)
  scope :unpaid, where(:status => PAYMENT_PENDING)

  def paid?
    status == RESOLVED
  end
  def unpaid?
    status == PAYMENT_PENDING
  end

  def page(page_number)
    return nil unless page_number
    per_page = 6
    start = per_page * ((page_number) - 1)
    tickets[(start..(start + per_page - 1))] # HACK
  end

  class << self

    def code?(code)
      code.match /\A#{Barcode::ORDER_REGEX_PARTS}\Z/
    end

    def page_code?(code)
      code.match /\A#{Barcode::PAGE_REGEX_PARTS}\Z/
    end

    def order_from_page_code(code)
      where(:code => code.match(/\A(#{Barcode::ORDER_REGEX_PARTS})/)[1]).try(:first)
    end

    def page_number_for_code(code)
      return nil unless page_code?(code)
      code.match(/\A#{Barcode::PAGE_REGEX_PARTS}\Z/)[1].try(:to_i)
    end

    def page_for_code(code)
      page page_number_for_code(code)
    end

  end
end
