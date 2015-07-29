require 'factory_girl'
Dir[Rails.root.join('db/spec/support/factories/*.rb')].each {|f| require f}

Genre.delete_all
Book.delete_all
User.delete_all
Bookshelf.delete_all
Friend.delete_all
Genrelist.delete_all
Request.delete_all
Blacklist.delete_all
Borrow.delete_all

# create 5 genres
FactoryGirl.create_list(:genre, 5)
# create 100 books
FactoryGirl.create_list(:book,100)
# create 5 user
FactoryGirl.create_list(:user,5)
# create bookshelves
FactoryGirl.create_list(:bookshelf,50)
# create friend list
FactoryGirl.create_list(:friend,7)
FactoryGirl.create_list(:mutual_friend,5)
# create genrelist
FactoryGirl.create_list(:genrelist,10)
# create black list
FactoryGirl.create(:blacklist)
# create borrow
FactoryGirl.create(:borrow)
# create request
FactoryGirl.create_list(:request,3)

# Administrator for test
#User.create!(
#	user_id: 0,
#	email: 'admin@admin.jp',
#	firstname: 'admin',
#	lastname: 'admin',
#	school: '青山学院大学',
#	lend_num: 5,
#	borrow_num: 3,
#	password: 'admin',
#	invitation_code: 'admin'
#)


# フロントエンド開発用ユーザー
User.create!(
	user_id: 1000,
	email: 'admin@admin.jp',
	firstname: '達也',
	lastname: '田中',
	school: '青山学院大学',
	lend_num: 5,
	borrow_num: 3,
	password: 'admin',
	invitation_code: 'admin'
)

4.times do |n|
	Friend.create!(
		user_id: 1000,
		friend_id: n,
		accepted: true,
	)
	Friend.create!(
		user_id: n,
		friend_id: 1000,
		accepted: true,
	)
end

require_relative '../app/api/v1/foreign'

V1::Foreign.search_book 'デスノート' do |item|
	book = Book.find_or_initialize_by isbn: item[:isbn]
	book.update item

	Bookshelf.create!(
		user_id: 1000,
		book_id: book.id,
		borrower_id: 0,
		rate: 3,
		comment: 'おすすめ〜'
	)
end
