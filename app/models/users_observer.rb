class UsersObserver < ActiveRecord::Observer
  observe :user
  
  def before_save(user)
    user.is_enabled = false if user.is_black_changed? && user.is_black
    true
  end
  
  def after_save(user)
    is_black_changed(user)
  end
  
  
  private 
  
  def is_black_changed(user)
    if user.is_black_changed?
      if user.is_black
        user.posts.each{ |p| p.destroy }
      else
        user.update_column :is_enabled, true
      end
    end
  end
  
end
