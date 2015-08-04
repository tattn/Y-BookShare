json.book Book.find_by id:borrow.book_id
# json.lender User.find_by user_id:borrow.lender_id
json.lender do
	json.partial!('users/user', user: User.find_by(user_id:borrow.lender_id))
end
json.dueDate borrow.due_date
