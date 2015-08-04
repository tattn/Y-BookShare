json.book Book.find_by id:lending.book_id
# json.borrower User.find_by user_id:lending.user_id
json.borrower do
	json.partial!('users/user', user: User.find_by(user_id:lending.user_id))
end
json.dueDate lending.due_date
