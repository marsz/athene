class UsersMonitorParser < ActiveRecord::Base
  belongs_to :site
  validates_uniqueness_of :label
  validates_presence_of :regex
  validates_presence_of :site_id
  validates_presence_of :label
  
  def to_regex
    eval(self.regex)
  end
end
