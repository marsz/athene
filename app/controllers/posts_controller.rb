class PostsController < ApplicationController
  def index
    # TODO user is enable/disable
    @posts = Post.meta_search(params)
    respond_to do |f|
      f.json { render :json => api_respond(@posts) }
      f.xml { render :xml => api_respond(@posts) }
    end
  end
  
  private
  def api_respond posts 
    result = []
    posts.each do |post|
      result << post.to_api_hash.merge(:user=>post.user.to_api_hash,:site=>post.site.to_api_hash)
    end
    { :posts => result, :total => posts.total_count}
  end
end
