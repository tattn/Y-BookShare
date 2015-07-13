
FactoryGirl.define do

  useridList = User.all.to_a.map(&:id)
  bookidList = Book.all.to_a.map(&:id)
  combination = useridList.product(bookidList).sort_by{rand}

  factory :bookshelf do
    sequence(:user_id) {|n| combination[n][0]}
    sequence(:book_id) {|n| combination[n][1]}
    borrower_id {0}
    rate {Random.rand(1..5)} 
  end
end
