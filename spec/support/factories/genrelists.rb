def genrelist_ids
	return @genrelist_ids if @genrelist_ids

	userid_list = User.all.to_a.map(&:id)
	genreid_list = Genre.all.to_a.map(&:id)
	@genrelist_ids = userid_list.product(genreid_list).to_a
end

FactoryGirl.define do 
  factory :genrelist do
    sequence(:user_id) {|n| genrelist_ids()[n-1][0]}
    sequence(:genre_id) {|n| genrelist_ids()[n-1][1]}
  end
end

