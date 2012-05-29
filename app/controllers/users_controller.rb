class UsersController < ApplicationController
  
  def index
    @users = User.non_blacklist.meta_search(params)
    respond_to do |f|
      f.json { render :json => api_respond(@users) }
      f.xml { render :xml => api_respond(@users) }
    end
  end
  
  def create
    site = Site.find_by_domain(params[:site])
    res = {}
    if site
      @user = User.new(:site_id=>site.id, :site_user_id => params[:user])
      @user.save
    end
    if @user && !@user.new_record?
      redirect_to user_path(@user)
    else
      res = {}
      if @user
        res[:errors] = @user.errors.full_messages if @user.errors.full_messages.size > 0
        res[:user] = User.find_by_site_id_and_site_user_id(@user.site_id,@user.site_user_id) if @user.site_id && @user.site_user_id
      end
      respond_to do |f|
        f.html { render :text =>  res.to_json}
        f.json { render :json => res.to_json }
        f.xml { render :xml => res.to_xml }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |f|
      f.html { render :text => {:user => api_respond(@user)}.to_json }
      f.json { render :json => {:user => api_respond(@user)}.to_json }
      f.xml { render :xml => {:user => api_respond(@user)}.to_xml }
    end
  end
  
  def is_black_true
    @user = User.find(params[:id])
    update_user(@user, :is_black => true)
  end
  
  def is_black_false
    @user = User.find(params[:id])
    update_user(@user, :is_black => false)
  end
  
  private
  
  def update_user(user, attributes)
    user.update_attributes(attributes)
    respond_to do |f|
      f.html { render :text => {:user => api_respond(user)}.to_json }
      f.json { render :json => {:user => api_respond(user)}.to_json }
      f.xml { render :xml => {:user => api_respond(user)}.to_xml }
    end
  end
  
  def api_respond users
    if users.is_a?(User)
      users.to_api_hash.merge(:site => users.site.to_api_hash)
    else
      result = []
      users.each do |user|
        result << api_respond(user)
      end
      { :users => result, :total => users.total_count}
    end
  end
end
