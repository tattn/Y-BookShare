require 'foreign'

module V1
	class Users < Grape::API

		# このクラス内で共通化出来る処理は helper に書く
    	helpers do
			include V1::Helpers    # emit_empty などを使えるようにする（必須）
			def find_by_id id
					user = User.find_by id: id
					emit_error "指定した user_id が見つかりません", 400, 1 unless user
				    user
			end
    	end

		resource :users do
			
			desc "Add a new user." 
			params do             
				requires :user_id, type: Integer, desc: "user id"
				requires :email, type: String, desc: "e-mail address"
				requires :firstname, type: String, desc: "firstname of the user"
				requires :lastname, type: String, desc: "lastname of the user"
				optional :school, type: String, desc: "school of the user"
			end

			post do              
				if Userid.find_by user_id: params[:user_id]
					emit_error "すでに登録されているID", 400, 1
				else
					if params[:school]
						Userid.create user_id: params[:user_id]
						User.create email: params[:email], firstname: params[:firstname], school: params[:school]
					else
						Userid.create user_id: params[:user_id]
						User.create email: params[:email], firstname: params[:firstname]
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
					requires :email, type: String, desc: "e-mail address"
					requires :firstname, type: String, desc: "firstname of the user"
					requires :lastname, type: String, desc: "lastname of the user"
					requires :school, type: String, desc: "school of the user"
					requires :lend_num, type: Integer, desc: "The number that the user has lent a book"
					requires :borrow_num, type: Integer, desc: "The number that the user has borrowed a book"
					requires :invitation_code, type: String, desc: "invitation code"
				end
				put '/' do
					@user = find_by_id params[:user_id]
					return unless @user
					@user.update email: params[:email]
					@user.update firstname: params[:firstname]
					@user.update lastname: params[:lastname]
					@user.update school: params[:school]
					@user.update lend_num: params[:lend_num]
					@user.update borrow_num: params[:borrow_num]
					@user.update invitation_code: params[:invitation_code]
					emit_empty
				end

				desc "Delete a user."
				delete '/' do
					@user = find_by_id params[:user_id]
					return unless @user
					@user.destroy
					emit_empty
				end

				desc "get the friends list"
				params do
					requires :token, type: String, desc: "Access token"
				end
				get '/friend', jbuilder: 'users/users' do
					authenticate!
					friend = Friend.where(user_id: params[:user_id], accepted: true).map(&:friend_id)
					@users =  User.where(id: friend)
				end
			end
		end
	end
end

