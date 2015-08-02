class Timeline
  include Mongoid::Document
	include Mongoid::Timestamps

	field :user_id, :type => Integer
	field :type, :type => String
	field :data, :type => Hash
end
