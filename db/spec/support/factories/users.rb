require 'securerandom'

FactoryGirl.define do

  firstname = ["上総","達也","英礼","拓人","侑弥"]
  lastname = ["坂本","田中","山本","小倉","原田"]
	comment = ["進撃の巨人読みたい", "解体新書面白い", "眠い"]

  factory :user do
  	sequence(:user_id) {|n| n}
	sequence(:email) {|n| "email#{n}@***.com"}
	firstname {firstname.pop}
	lastname {lastname.pop}
	sequence(:lend_num) {|n| if n==1 then 1 else 0 end}
	sequence(:borrow_num) {|n| if n==2 then 1 else 0 end}
	school {"青山学院大学"}
	password {'1234'}
	comment { comment.sample }
	sequence(:invitation_code) {|n| SecureRandom.hex }
  end
end

