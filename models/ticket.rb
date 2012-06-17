class Ticket < ActiveRecord::Base

  def scanned?
    scanned.length > 0
  end

  def scanned(code)
    @scans ||= Scan.find_all_by_ticket_code(code)
  end
end
