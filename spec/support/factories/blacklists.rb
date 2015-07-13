
FactoryGirl.define do
  factory :blacklist do
	user_id {Userid.all.to_a.map(&:id).sample}	
	bother_id {Userid.all.to_a.map(&:id).sample}
  end
end

