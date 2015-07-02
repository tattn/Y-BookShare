module BookShare
  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do
			#TODO: 認証作る
      # def current_user
      #   @current_user ||= User.authorize!(env)
      # end
      #
      # def authenticate!
      #   error!('401 Unauthorized', 401) unless current_user
      # end
    end

    resource :bookshelf do
      desc "Return a my bookshelf."
      get :my do
        # authenticate!
        # current_user.bookshelf # TODO: てきとーに書いた、本棚は複数ある？
				{ :book_ids => [1234, 9876, 5555], :user_id => 1 } # FIXME: This is test!!!
      end

      desc "Return a bookshelf by ID."
      params do
        requires :id, type: Integer, desc: "User ID."
      end
      route_param :id do
        get do
          # User.find(params[:id]).bookshelf # TODO: 同上
        end
      end

      desc "Create a new bookshelf."
      params do
				requires :info, type: String, desc: "Bookshelf information."
      end
      post do
        # authenticate!
        # BookShelf.create!({
        #                    user: current_user,
        #                    info: params[:info]
        #                })
      end

      desc "Update a bookshelf."
      params do
        requires :id, type: String, desc: "Bookshelf ID."
        requires :info, type: String, desc: "Information for updating."
      end
      put ':id' do
        # authenticate!
        # current_user.bookshelf.find(params[:id]).update({
        #                                                    user: current_user,
        #                                                    info: params[:info]
        #                                                })
      end

      desc "Delete a bookshelf."
      params do
        requires :id, type: String, desc: "Bookshelf ID."
      end
      delete ':id' do
        # authenticate!
        # current_user.bookshelf.find(params[:id]).destroy
      end
    end
  end
end
