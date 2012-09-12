FactoryGirl.define do

  factory :ticket do
    association :order
    association :ticket_type
    code { "#{order.code}-#{"%04d" % rand(9999)}" }
    full_name { Faker::Name.name }
    gender { ["Male","Female",""].sample }
    postcode { Faker::AddressAU.zip_code }
    after_build do |ticket|
      ticket.ticket_type = FactoryGirl.build(:ticket_type)
    end
  end

  factory :ticket_type do
    title { Faker::Lorem.words(3) }
  end
end
