require 'securerandom'

FactoryGirl.define do

  firstname = ["上総","達也","英礼","拓人","侑弥"]
  lastname = ["坂本","田中","山本","小倉","原田"]

  factory :user do
	sequence(:email) {|n| "email#{n}@***.com"}
	sequence(:firstname) {|n| firstname.pop}
	sequence(:lastname) {|n| lastname.pop}
	sequence(:school) {|n| "青山学院大学"}
	sequence(:password) {|n| '1234'}
	sequence(:invitation_code) {|n| SecureRandom.hex }
  end
end

