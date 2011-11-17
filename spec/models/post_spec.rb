require 'spec_helper'

describe Post do
  include DataMaker
  before do
    init_all_data
  end
  it {should belong_to(:site)}
  it {should belong_to(:user)}
  it {should validate_uniqueness_of(:site_post_id).scoped_to([:site_id])}
  it {should validate_presence_of(:site_id)}
  it {should validate_presence_of(:site_post_id)}
  it {should validate_presence_of(:user_id)}
  it {should validate_presence_of(:url)}
  it {should validate_presence_of(:date)}
  it {should validate_presence_of(:title)}
  pending "sync site id"
end
