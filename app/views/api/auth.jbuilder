json.status 200
json.token @token
json.users do
	json.partial!('users/user', user: @user)
end
