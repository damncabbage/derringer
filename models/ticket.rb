class Ticket < ActiveRecord::Base
  belongs_to :order

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
