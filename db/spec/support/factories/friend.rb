
def friend_ids
	return @friend_ids if @friend_ids
	userid_list = User.all.to_a.map(&:user_id)
	@friend_ids = userid_list.combination(2).to_a
end

FactoryGirl.define do
  factory :friend do
	sequence(:user_id) {|n| friend_ids()[n-1][0]}
    sequence(:friend_id) {|n| friend_ids()[n-1][1]}
	sequence(:accepted) {|n| if n-1 < 5 then true else false end}
  end
  factory :mutual_friend ,class: Friend do
	sequence(:user_id) {|n| Friend.all.to_a.map(&:friend_id)[n-1]}
    sequence(:friend_id) {|n| Friend.all.to_a.map(&:user_id)[n-1]}
	accepted {true}
  end
end

