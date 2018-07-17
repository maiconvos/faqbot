FactoryBot.define do
  factory :link do
    url FFaker::Internet.domain_name
    company
  end
end
