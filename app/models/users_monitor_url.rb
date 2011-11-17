class UsersMonitorUrl < ActiveRecord::Base
  scope :enabled, where(:is_enabled=>true)
  
  belongs_to :parser, :class_name => "UsersMonitorParser", :foreign_key => :parser_id
  belongs_to :site
  validates_uniqueness_of :url
  validates_presence_of :label
  validates_presence_of :site_id
  validates_presence_of :parser_id
  
  def monitored
    update_attributes(:monitored_at => Time.now)
  end
end
