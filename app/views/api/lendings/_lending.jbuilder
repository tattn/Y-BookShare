json.book Book.find_by id:lending.book_id
json.borrower User.find_by user_id:lending.user_id
json.dueDate lending.due_date
