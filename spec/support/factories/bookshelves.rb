def bookshelf_ids
  return @bookshelf_ids  if @bookshelf_ids
  userid_list = User.all.to_a.map(&:id)
  bookid_list = Book.all.to_a.map(&:id)
  @bookshelf_ids  = userid_list.product(bookid_list).to_a
end

FactoryGirl.define do
  factory :bookshelf do
    sequence(:user_id) {|n| bookshelf_ids()[n-1][0]}
    sequence(:book_id) {|n| bookshelf_ids()[n-1][1]}
    sequence(:borrower_id) {|n| if n==1 then 2 else 0 end}
    rate {Random.rand(1..5)}
  end
end
