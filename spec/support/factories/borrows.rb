
FactoryGirl.define do
  factory :borrow do
	user_id {Userid.all.to_a.map(&:id).sample}	
	book_id {Book.all.to_a.map(&:id).sample}
	lender_id {Userid.all.to_a.map(&:id).sample}
	sequence(:due_date) {|n| Random.rand(Date.parse("2015/07/01") .. Date.parse("2016/07/01"))} 
  end
end

