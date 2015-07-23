json.status 200
json.bookshelves @bookshelves do |bookshelf|
	json.partial!('bookshelves/bookshelf', bookshelf: bookshelf)
end
