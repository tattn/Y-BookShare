
FactoryGirl.define do
  factory :book do
	sequence(:title) {|n| "Book#{n}"}
	genre {Genre.all.to_a.map(&:name).sample}	
  end
end

