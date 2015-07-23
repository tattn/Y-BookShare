json.status 200
json.bookshelf do
	json.partial!('bookshelves/bookshelf', bookshelf: @bookshelf)
end
