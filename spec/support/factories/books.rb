
FactoryGirl.define do
  factory :book do
	sequence(:title) {|n| "Book#{n}"}
	genre_id {Genre.all.to_a.map(&:id).sample}	
  end
end

