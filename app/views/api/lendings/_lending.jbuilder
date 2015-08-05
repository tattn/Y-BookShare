json.book do
	json.partial!('books/book', book: Book.find_by(id:lending.book_id))
end
json.borrower do
	json.partial!('users/user', user: User.find_by(user_id:lending.user_id))
end
json.dueDate lending.due_date
