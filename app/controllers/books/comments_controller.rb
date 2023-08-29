# frozen_string_literal: true

class Books::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def render_commentable
    @book = @commentable
    flash.now[:alert] = @comment.errors.full_messages_for(:body).first
    render 'books/show'
  end
end
