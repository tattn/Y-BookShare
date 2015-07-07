json.status 200
json.book do
	json.partial!('books/book', book: @book)
end
