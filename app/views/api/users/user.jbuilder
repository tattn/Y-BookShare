json.status 200
json.user do
	json.partial!('users/user', user: @user)
end
