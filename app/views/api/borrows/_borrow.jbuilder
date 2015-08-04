json.book Book.find_by id:borrow.book_id
json.lender User.find_by user_id:borrow.lender_id
json.dueDate borrow.due_date
