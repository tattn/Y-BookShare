require 'factory_girl'
Dir[Rails.root.join('spec/support/factories/*.rb')].each {|f| require f}


# create 5 genres
FactoryGirl.create_list(:genre, 5)

# create 100 books
FactoryGirl.create_list(:book,100)

