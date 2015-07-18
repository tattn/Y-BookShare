require 'factory_girl'
Dir[Rails.root.join('spec/support/factories/*.rb')].each {|f| require f}

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
User.create!(
	user_id: 12345678,
	email: 'admin@admin.jp',
	firstname: 'admin',
	lastname: 'admin',
	school: '青山学院大学',
	lend_num: 5,
	borrow_num: 3,
	password: 'admin',
	invitation_code: 'admin'
)

