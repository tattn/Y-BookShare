

FactoryGirl.define do
  factory :book do
	sequence(:title) {|n| "Book#{n}"}
	sequence(:isbn) {|n| "testisbn#{n}"}
	sequence(:author) {|n| "author#{n}"}
	sequence(:manufacturer) {|n| "manufacturer#{n}"}
	genre_id {Genre.all.to_a.map(&:id).sample}	
  end
end
