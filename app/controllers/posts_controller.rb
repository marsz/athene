class PostsController < ApplicationController
  def index
    # TODO user is enable/disable
    @posts = Post.includes([:user,:site]).scoped.page(params[:page]).order("date DESC")
    if params[:q]
      @posts = @posts.where("title LIKE ?", "%#{params[:q]}%")
    end
    respond_to do |f|
      f.json { render :json => posts_to_api_redpond(@posts) }
      f.xml { render :xml => posts_to_api_redpond(@posts) }
    end
  end
  
  private
  def posts_to_api_redpond posts 
    result = []
    posts.each do |post|
      result << api_respond(post).merge({:user=>api_respond(post.user),:site=>api_respond(post.site)})
    end
    result
  end
end
