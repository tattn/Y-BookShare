
require 'securerandom'
FactoryGirl.define do
  factory :userid do
	user_id {SecureRandom.random_number(10**8)}
  end
end

