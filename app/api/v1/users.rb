require 'foreign'

module V1
	class Users < Grape::API

		# このクラス内で共通化出来る処理は helper に書く
    	helpers do
			include V1::Helpers    # emit_empty などを使えるようにする（必須）
			def find_by_id user_id
				user = User.find_by user_id: user_id
				emit_error "指定した user_id が見つかりません", 400, 1 unless user
				user
			end
    	end

		resource :users do
			desc "Add a new user." 
			params do             
				requires :email, type: String, desc: "e-mail address"
				requires :password, type: String, desc: "password"
				requires :firstname, type: String, desc: "firstname of the user"
				requires :lastname, type: String, desc: "lastname of the user"
				optional :school, type: String, desc: "school of the user"
			end
			post do              
				if User.find_by user_id: params[:user_id]
					emit_error "すでに登録されているID", 400, 1
				else
					new_id = User.maximum(:user_id) + 1
					if params[:school]
						User.create user_id: new_id, email: params[:email], password: params[:password], firstname: params[:firstname], lastname: params[:lastname], school: params[:school]
					else
						User.create user_id: new_id, email: params[:email], password: params[:password], firstname: params[:firstname], lastname: params[:lastname]
					end
					emit_empty                               
				end
			end

			params do
				requires :user_id, type:Integer, desc: "user id"
			end
			route_param :user_id do

				desc "Get a user"
				get '/', jbuilder: 'users/user' do
					@user = find_by_id params[:user_id]
				end

				desc "Change property of a user."
				params do
					optional :email, type: String, desc: "e-mail address"
					optional :firstname, type: String, desc: "firstname of the user"
					optional :lastname, type: String, desc: "lastname of the user"
					optional :school, type: String, desc: "school of the user"
					optional :lend_num, type: Integer, desc: "The number that the user has lent a book"
					optional :borrow_num, type: Integer, desc: "The number that the user has borrowed a book"
					optional :invitation_code, type: String, desc: "invitation code"
				end
				put '/' do
					@user = find_by_id params[:user_id]
					return unless @user
						@user.update email: params[:email] if params[:email]
						@user.update firstname: params[:firstname] if params[:firstname]
						@user.update lastname: params[:lastname] if params[:lastname]
						@user.update school: params[:school] if params[:school] 
						@user.update lend_num: params[:lend_num] if params[:lend_num]
						@user.update borrow_num: params[:borrow_num] if params[:borrow_num]
						@user.update invitation_code: params[:invitation_code] if params[:invitation_code]
					emit_empty
				end

				desc "Delete a user."
				delete '/' do
					@user = find_by_id params[:user_id]
					return unless @user
					@user.destroy
					emit_empty
				end

				resource :friend do
					desc "get the friends list"
					params do
						requires :token, type: String, desc: "Access token"
					end
					get '/', jbuilder: 'users/users' do
						user = authenticate!
						friend = Friend.where(user_id: user.user_id, accepted: true).map(&:friend_id)
						@users =  User.where(user_id: friend)
					end

					desc "Add a new friend." 
					params do              
						requires :token, type: String, desc: "Access token"
						requires :friend_id, type: Integer, desc: "friend id"
					end
					post do               
						user = authenticate!
						if Friend.find_by user_id: user.user_id, friend_id: params[:friend_id]
							emit_error "すでに登録されている友達", 400, 1 
						else
							Friend.create user_id: user.user_id, friend_id: params[:friend_id], accepted: false
							emit_empty                              
						end
					end

					params do
						requires :token, type: String, desc: "Access token"
						requires :friend_id, type: Integer, desc: "friend id"
					end
					route_param :friend_id do
						desc "Delete a friend."
						delete '/' do
							user = authenticate!
							@friend = Friend.find_by user_id: user.user_id, friend_id: params[:friend_id], accepted: true
							@partner = Friend.find_by  user_id: user.user_id,friend_id: params[:user_id], accepted: true
							unless @friend then
								emit_error "存在しない友達", 400, 1
							else
								@friend.destroy
								@partner.destroy
								emit_empty
							end	
						end
					end

					resource :new do
						desc "get the applicants"
						params do
							requires :token, type: String, desc: "Access token"
						end
						get '/', jbuilder: 'users/users' do
							user = authenticate!
							applicants = Friend.where(friend_id: user.user_id, accepted: false).map(&:user_id)
							@users =  User.where(user_id: applicants)
						end

						params do
							requires :token, type: String, desc: "Access token"
							requires :friend_id, type: Integer, desc: "friend id"
						end
						route_param :friend_id do

							desc "follow back"
							put '/' do
								user = authenticate!
								@friend = Friend.find_by user_id: params[:friend_id], friend_id: user.user_id
								unless @friend then
									emit_empty
								else	
									@friend.update accepted: true
									Friend.create user_id: user.user_id, friend_id: params[:friend_id], accepted: true
									emit_empty
								end
							end

							desc "reject friend request"
							delete '/' do
								user = authenticate!
								@request = Friend.find_by user_id: params[:friend_id], friend_id: user.user_id, accepted: false
								unless @request then
									emit_error "存在しない友達申請", 400, 1
								else
									@request.destroy
									emit_empty
								end	
							end

						end
					end

				end
			end
		end
	end
end
