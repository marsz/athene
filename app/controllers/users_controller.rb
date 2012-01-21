class UsersController < ApplicationController
  
  def index
    @users = User.search(params)
    respond_to do |f|
      f.json { render :json => api_respond(@users) }
      f.xml { render :xml => api_respond(@users) }
    end
  end
  
  private
  def api_respond users
    result = []
    users.each do |user|
      result << user.to_api_hash.merge(:site => user.site.to_api_hash)
    end
    { :users => result, :total => users.total_count}
  end
end
