class AddColumnCheckStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :check_state, :string, :default => "idle", :after => :checked_at
    User.where(:check_state => nil).each do |u|
      u.update_attributes(:check_state => "idle")
    end
  end
end
