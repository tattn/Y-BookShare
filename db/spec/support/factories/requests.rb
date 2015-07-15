FactoryGirl.define do
  factory :request do
	user_id {1}
    sequence(:sender_id) {|n| 2+n }
    sequence(:book_id) {|n| 1+n }
	sequence(:accepted) {|n| [true,false,nil][n-1]}
  end
end

