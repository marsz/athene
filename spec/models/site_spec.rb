require 'spec_helper'

describe Site do
  include DataMaker
  before do
    init_all_data
  end
  it {should validate_presence_of(:url)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:domain)}
  it {should validate_uniqueness_of(:domain)}
  it {should validate_format_of(:domain).with("wretch")}
  it {should validate_format_of(:domain).not_with("http://wretch.cc")}
  it {should have_many(:users_monitor_urls)}
  it {should have_many(:users)}
  it {should have_many(:posts)}
  
end
