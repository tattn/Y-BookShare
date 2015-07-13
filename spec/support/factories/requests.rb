
FactoryGirl.define do
  factory :request do
	user_id {Userid.all.to_a.map(&:id).sample}	
	sender_id {Userid.all.to_a.map(&:id).sample}
	book_id {Book.all.to_a.map(&:id).sample}
	sequence(:accepted) {|n| [true,false][rand(2)]} 
  end
end

