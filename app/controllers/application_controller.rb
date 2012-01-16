class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def api_respond obj
    send "api_respond_#{obj.class.to_s.underscore}", obj
  end
  
  private
  def api_respond_post post
    { :id => post.id,
      :title => post.title,
      :date => post.date,
      :url => post.url
    }
  end
  def api_respond_site site
    { :id => site.id, :name => site.name }
  end
  def api_respond_user user
    { :id => user.id, :site_user_id => user.site_user_id }
  end
    
end
