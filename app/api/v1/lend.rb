
module V1
  class Lend < Grape::API
    # このクラス内で共通化出来る処理は helper に書く
    helpers do
      include V1::Helpers    # emit_empty などを使えるようにする（必須）
    end

    params do
      requires :token, type: String, desc: "Access token"
    end
    resource :my do
      resource :lend do
        get '/', jbuilder: 'lendings/lendings' do
          authenticate!
          @lendings = Borrow.where(lender_id: @current_user.user_id)
        end

        params do
          requires :book_id, type: Integer, desc: "book id"
          requires :borrower_id, type: Integer, desc: "borrower id"
          optional :due_date, type: String, desc: "due date"
        end
        post '/', jbuilder: 'empty' do
          authenticate!

          emit_error! "すでに貸している本です", 400, 1 if Borrow.find_by lender_id: @current_user.user_id, book_id: params[:book_id]

          @borrow_book = Bookshelf.find_by user_id: @current_user.user_id, book_id: params[:book_id]
          emit_error! "存在しない本を借りようとしています", 400, 1 unless @borrow_book

          if @borrow_book.borrower_id == 0
            if params[:due_date]
              Borrow.create user_id: @current_user.user_id, book_id: params[:book_id], lender_id: params[:lender_id], due_date: params[:due_date]
            else
              Borrow.create user_id: params[:borrower_id], book_id: params[:book_id], lender_id: @current_user.user_id
            end
            @borrow_book.update borrower_id: @current_user.user_id
          else
            emit_error! "すでに借りられている本を借りようとしています", 400, 1
          end
        end

        params do
          requires :book_id, type: Integer, desc: "book id"
        end
        route_param :book_id do
          delete '/', jbuilder: 'empty' do
            authenticate!

            @borrow_book = Borrow.find_by lender_id: @current_user.user_id, book_id: params[:book_id]
            emit_error! "存在しない本の削除", 400, 1 unless @borrow_book

            @borrow_bookshelf = Bookshelf.find_by user_id: @current_user.user_id, book_id: params[:book_id]
            emit_error! "存在しない本棚の本の返却", 400, 1 unless @borrow_bookshelf

            @borrow_book.delete
            @borrow_bookshelf.update borrower_id: 0
          end
        end
      end
    end
  end
end
