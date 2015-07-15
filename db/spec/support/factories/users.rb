require 'securerandom'

FactoryGirl.define do

  firstname = ["上総","達也","英礼","拓人","侑弥"]
  lastname = ["坂本","田中","山本","小倉","原田"]

  factory :user do
	sequence(:email) {|n| "email#{n}@***.com"}
	firstname {firstname.pop}
	lastname {lastname.pop}
	sequence(:lend_num) {|n| if n==1 then 1 else 0 end}
	sequence(:borrow_num) {|n| if n==2 then 1 else 0 end}
	school {"青山学院大学"}
	password {'1234'}
	sequence(:invitation_code) {|n| SecureRandom.hex }
  end
end

