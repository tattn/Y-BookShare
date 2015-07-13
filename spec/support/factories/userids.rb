
require 'securerandom'
FactoryGirl.define do
  factory :userid do
	sequence(:user_id) {|n| SecureRandom.random_number(10**8)}
  end
end

