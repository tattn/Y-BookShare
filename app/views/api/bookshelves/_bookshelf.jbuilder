json.userId bookshelf.user_id
json.borrowerId bookshelf.borrower_id
json.rate bookshelf.rate
json.book do
	json.partial!('books/book', book: Book.find_by(id: bookshelf.book_id))
end
json.createdAt bookshelf.created_at
