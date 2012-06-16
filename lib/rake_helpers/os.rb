module RakeHelpers
  module OS

    def linux?
      @linux ||= (`uname -a | grep -ic linux`.to_i > 0)
    end
    def mac?
      @mac ||= !linux? && (`uname -a | grep -ic darwin`.to_i > 0)
    end

  end
end
