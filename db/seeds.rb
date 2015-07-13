require 'factory_girl'
Dir[Rails.root.join('spec/support/factories/*.rb')].each {|f| require f}



# create 5 genres
FactoryGirl.create_list(:genre, 5)

# create 100 books
FactoryGirl.create_list(:book,100)

# create 5 user ids
FactoryGirl.create_list(:userid,5)

# create 5 user
FactoryGirl.create_list(:user,5)

# create bookshelves
FactoryGirl.create_list(:bookshelf,50)

#*ここまで作った*

# create friend list
FactoryGirl.create_list(:friend,500)

# create request
FactoryGirl.create_list(:request,100)

# create black list
FactoryGirl.create_list(:blacklist,50)

# create borrow list
FactoryGirl.create_list(:borrow,100)

# create genrelist
FactoryGirl.create_list(:genrelist,100)

