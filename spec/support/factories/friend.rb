
FactoryGirl.define do
  factory :friend do
	user_id {Userid.all.to_a.map(&:id).sample}	
	friend_id {Userid.all.to_a.map(&:id).sample}
	sequence(:accepted) {|n| [true,false][rand(2)]} 
  end
end

