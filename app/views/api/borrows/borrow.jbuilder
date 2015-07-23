json.status 200
json.borrow do
	json.partial!('borrows/borrow', borrow: @borrow)
end
