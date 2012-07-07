class Order < ActiveRecord::Base
  has_many :tickets

  class << self

    def code?(code)
      code.match /\A#{Barcode::ORDER_REGEX_PARTS}\z/
    end

    def page_code?(code)
      code.match /\A#{Barcode::PAGE_REGEX_PARTS}\z/
    end

    def page_number_for_code(code)
      return nil unless page_code?(code)
      code.match(/\A#{Barcode::PAGE_REGEX_PARTS}\z/)[1].try(:to_i)
    end

    def page(page_number)
      return nil unless page_number
      [] # TODO
    end

    def page_for_code(code)
      page page_number_for_code(code)
    end

  end
end
