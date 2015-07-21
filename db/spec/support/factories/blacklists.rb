def blacklist_id
	return @blacklist_id if @blacklist_id

	userid_list = User.all.to_a.map(&:user_id)
	userid_list = userid_list.permutation(2).to_a
	user_list = Friend.all.to_a.map(&:user_id)
	friend_list = Friend.all.to_a.map(&:friend_id)
	friend_list = user_list.zip(friend_list)

	userid_list.each do |n|
		if friend_list.index(n)==nil then
			@blacklist_id = n
		end
	end
	@blacklist_id
end


FactoryGirl.define do
  factory :blacklist do
	user_id {blacklist_id()[0]}	
	bother_id {blacklist_id()[1]}
  end
end