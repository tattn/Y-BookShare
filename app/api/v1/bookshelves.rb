require 'foreign'

module V1
  class Bookshelves < Grape::API

    # このクラス内で共通化出来る処理は helper に書く
    helpers do
      include V1::Helpers    # emit_empty などを使えるようにする（必須）

      def find_by_id user_id, book_id
        @bookshelf = Bookshelf.find_by user_id: user_id, book_id: book_id
        emit_error "指定した user_id または book_id が見つかりません", 400, 1 unless @bookshelf
        @bookshelf
      end

      # Strong parameter, but the following method is not secure.
      def bookshelf_params
        ActionController::Parameters.new(params).permit :borrower_id, :rate, :comment
      end
    end

    resource :bookshelves do

      params do
        requires :user_id, type: Integer, desc: "UserID"
      end
      route_param :user_id do


        desc "Get a bookshelf."
        get '/' , jbuilder: 'bookshelves/bookshelves' do
          @bookshelves = Bookshelf.where user_id: params[:user_id]
        end

        desc "post a bookshelf"
        params do
          requires :book_id, type: Integer, desc: "adding book ID"
        end
        post '/' , jbuilder: 'empty' do
          if Bookshelf.find_by user_id: params[:user_id], book_id: params[:book_id]
            emit_error! "すでに登録されているタイトル", 400, 1
          else
            bookshelf = Bookshelf.create user_id: params[:user_id], book_id: params[:book_id], borrower_id: 0
						data = { bookshelf: bookshelf.attributes }
						data[:book_id] = Book.find_by id: bookshelf.book_id
						data[:user_id] = User.find_by user_id: bookshelf.user_id
						data.delete "updated_at"
						data.delete "created_at"
						add_timeline params[:user_id], "bookshelf", data
          end
        end

        resource :search do
          params do
            optional :book_id, type: Integer, desc: "bookID"
            optional :title, type: String, desc: "title of the book"
          end
          get '/' , jbuilder: 'bookshelves/bookshelves' do
            if params[:book_id]
              @bookshelves = Bookshelf.where( user_id: params[:user_id], book_id: params[:book_id])
            else
              if params[:title]  #sample:   http://localhost:3000/bookshare/api/v1/bookshelves/1/search?title=Book1
                id_by_title = Book.where("title like '%" + params[:title] + "%'").map(&:id)
                @bookshelves = Bookshelf.where(user_id: params[:user_id], book_id: id_by_title)
              end
            end
          end
        end

        desc "Delete a bookshelf."
        delete '/', jbuilder: 'empty' do
          bookshelf = Bookshelf.where(user_id: params[:user_id])
          emit_error! "指定した user_id の本棚が見つかりません", 400, 1 unless bookshelf

          bookshelf.each do |book|
            book.destroy
          end
        end

        params do
          requires :book_id, type: Integer, desc: "bookID"
        end
        route_param :book_id do

          get '/', jbuilder: 'bookshelves/bookshelf' do
            @bookshelf = find_by_id params[:user_id], params[:book_id]
          end

          desc "Change property of a book on bookshelf."
          params do
            optional :borrower_id, type: Integer, desc: "borrowerID"
            optional :rate, type: Integer, desc: "interest rate of book"
            optional :comment, type: String, desc: "review of book"
          end
          put '/', jbuilder: 'empty' do
            bookshelf = find_by_id params[:user_id], params[:book_id]
            return unless bookshelf
            bookshelf.update bookshelf_params
          end

          desc "Delete a book on bookshelf."
          delete '/', jbuilder: 'empty' do
            bookshelf = find_by_id params[:user_id], params[:book_id]
            return unless bookshelf
            bookshelf.destroy
          end
        end
      end
    end
  end
end
