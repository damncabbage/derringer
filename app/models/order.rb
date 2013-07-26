class Order < ActiveRecord::Base

  RESOLVED = 'resolved'
  PAYMENT_PENDING = 'payment_pending'

  has_many :tickets

  default_scope where("orders.created_at > '#{Time.now.year}-01-01'") # Dat sum hack.

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
    start = per_page * ((page_number/10) - 1)
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
