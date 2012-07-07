module Barcode

  SEP = '-'

  ORDER_PREFIX = 'S'
  ORDER_LENGTH = 7
  ORDER_CHARS = '0123456789ACEFGHJKLMNPQRSTWXY'

  TICKET_CHARS = '0123456789ABCDEF'

  PAGE_PREFIX = '%M'

  ORDER_REGEX_PARTS = "#{ORDER_PREFIX}#{SEP}[#{ORDER_CHARS}]{#{ORDER_LENGTH}}"
  TICKET_REGEX_PARTS = "#{ORDER_REGEX_PARTS}#{SEP}[#{TICKET_CHARS}]{4}"
  PAGE_REGEX_PARTS = "#{ORDER_REGEX_PARTS}#{SEP}#{PAGE_PREFIX}([0-9]{2})"

end
