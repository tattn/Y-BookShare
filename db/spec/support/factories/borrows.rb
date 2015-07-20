
FactoryGirl.define do
  factory :borrow do
	user_id {User.find_by(id: 2).user_id}
	book_id {1}
	lender_id {1}
	sequence(:due_date) {|n| Random.rand(Date.parse("2015/07/01") .. Date.parse("2016/07/01"))} 
  end
end

