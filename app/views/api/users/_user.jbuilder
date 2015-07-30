json.userId user.user_id
json.email user.email
json.firstname user.firstname
json.lastname user.lastname
json.school user.school
json.lendNum user.lend_num
json.borrowNum user.borrow_num
json.bookNum Bookshelf.where(user_id: user.user_id).count


