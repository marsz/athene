require 'spec_helper'

describe UsersMonitorParser do
  include DataMaker
  before do
    init_all_data
  end
  it {should belong_to(:site)}
  it {should validate_uniqueness_of(:label)}
  it {should validate_presence_of(:regex)}
  it {should validate_presence_of(:site_id)}
  it {should validate_presence_of(:label)}
  
  pending "to_regex"
end
