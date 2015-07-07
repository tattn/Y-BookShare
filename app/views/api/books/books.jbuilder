json.status 200
json.books @books do |book|
	json.partial!('books/book', book: book)
end
