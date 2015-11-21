FactoryGirl.define do
  factory :channel do
    name  { FFaker::Name.name }
    user
  end
end