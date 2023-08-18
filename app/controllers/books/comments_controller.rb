# frozen_string_literal: true

class Books::CommentsController < CommentsController
  before_action :set_commentable

  def create
    book = Book.find(params[:book_id])
    comment = book.comments.build(comment_params)
    comment.user = current_user
    comment.save!
    redirect_to book, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end
end
