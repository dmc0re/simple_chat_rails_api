FactoryGirl.define do
  factory :message do
    text "text"
    channel
    user
  end
end