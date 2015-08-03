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
						# 自動変更かレスポンスフィールドの命名規則の変更を考えたほうがいいかもしれない
            bookshelf = Bookshelf.create user_id: params[:user_id], book_id: params[:book_id], borrower_id: 0
						data = bookshelf.attributes
						data[:book] = Book.find_by(id: bookshelf.book_id).attributes
						data[:book][:bookId] = data[:book].book_id
						data[:book][:genreId] = data[:book].genre_id
						data[:book][:coverImageUrl] = data[:book].cover_image_url
						data[:book][:publicationDate] = data[:book].publication_date
						data[:book][:amazonUrl] = data[:book].amazon_url
						data[:book].delete :book_id
						data[:book].delete :genre_id
						data[:book].delete :cover_image_url
						data[:book].delete :publication_date
						data[:book].delete :amazon_url
						data[:user] = User.find_by(user_id: bookshelf.user_id).attributes
						data[:user][:userId] = data[:user].user_id
						data[:user][:imageUrl] = data[:user].image_url
						data[:user][:lendNum] = data[:user].lend_num
						data[:user][:borrowNum] = data[:user].borrow_num
						data[:user][:bookNum] = data[:user].book_num
						data[:user].delete :user_id
						data[:user].delete :image_url
						data[:user].delete :lend_num
						data[:user].delete :borrow_num
						data[:user].delete :book_num
						data[:book].delete "updated_at"
						data[:book].delete "created_at"
						data[:user].delete "updated_at"
						data[:user].delete "created_at"
						data[:user].delete "icon_name"
						data[:user].delete "icon_data"
						data.delete "updated_at"
						data.delete "created_at"
						add_timeline params[:user_id], "bookshelf", { bookshelf: data }
          end
        end

        resource :search do
          params do
            optional :title, type: String, desc: "title of the book"
						optional :start, type: Integer, default: 1, desc: "position of all results"
          end
          get '/' , jbuilder: 'bookshelves/bookshelves' do
						@bookshelves = []
						result_max = 10         # 取得件数
						start = params[:start]  # 取得開始位置

						if params[:title]  #sample:   http://localhost:3000/bookshare/api/v1/bookshelves/1/search?title=Book1
							id_by_title = Book.where("title like '%" + params[:title] + "%'").map(&:id)
							bookshelves = Bookshelf.where(user_id: params[:user_id], book_id: id_by_title)
							book_count = bookshelves.count
							if book_count > result_max * (start - 1)
								book = bookshelves.offset(10 * start).to_a
								@bookshelves += book
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
