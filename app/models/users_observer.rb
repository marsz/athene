class UsersObserver < ActiveRecord::Observer
  observe :user
  
  def before_save(user)
    user.is_enabled = false if user.is_black_changed? && user.is_black
  end
  
end
