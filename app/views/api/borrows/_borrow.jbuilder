json.book do
	json.partial!('books/book', book: Book.find_by(id:borrow.book_id))
end
json.lender do
	json.partial!('users/user', user: User.find_by(user_id:borrow.lender_id))
end
json.dueDate borrow.due_date
