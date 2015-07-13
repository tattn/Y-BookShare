
FactoryGirl.define do
  factory :genrelist do
	user_id {Userid.all.to_a.map(&:id).sample}	
	genre_id {Genre.all.to_a.map(&:id).sample}	
  end
end

