FactoryGirl.define do

  factory :order do
    code do
      chars = '0123456789ACEFGHJKLMNPQRSTWXY'.split('')
      code  = (0..6).map { chars[rand(chars.length)] }.join
      "S-#{code}"
    end
    bpay_crn { rand(89999) + 10000 }
    status "resolved"
    full_name { Faker::Name.name }
    phone { Faker::PhoneNumberAU.phone_number }
    state { Faker::AddressAU.state_abbr }
    address { "#{Faker::Address.street_address}, #{Faker::AddressAU.city(state)}" }
    postcode { Faker::AddressAU.zip_code(state) }
    underage_tickets { rand(2) }
    tickets_count 0 # TODO
  end

  factory :order_with_ticket, :parent => :order do
    after_build do |order|
      order.tickets << FactoryGirl.build(:ticket, :order => order)
    end
  end

  factory :order_with_tickets, :parent => :order do
    after_build do |order| 
      3.times do
        order.tickets << FactoryGirl.build(:ticket, :order => order)
      end
    end
  end

end
