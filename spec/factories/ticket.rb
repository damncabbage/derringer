FactoryGirl.define do

  factory :ticket do
#    association :order
#    association :ticket_type
    code { "#{order.code}-#{"%04d" % rand(9999)}" }
    full_name { Faker::Name.name }
    gender { ["Male","Female",""].sample }
    postcode { Faker::AddressAU.postcode }
    after :build do |ticket, ctx|
      ticket.order       ||= FactoryGirl.build(:order)
      ticket.ticket_type ||= FactoryGirl.build(:ticket_type)
    end
  end

  factory :ticket_type do
    title { "SMASH! #{rand(2007..2039)} Day Pass" }
  end
end
