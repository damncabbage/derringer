FactoryGirl.define do

  factory :scan do
    order_id { rand(99999) + 1 }
    ticket_id { rand(99999) + 1 }
    order_code do
      chars = (0..9).to_a + ('A'..'Z').to_a
      code  = (0..9).map { chars[rand(chars.length)] }.join
      "S-#{code}"
    end
    ticket_code do
      "#{order_code}-#{"%04d" % rand(9999)}"
    end
    booth { Faker::Internet.ip_v4_address }
  end

end
