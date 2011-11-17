require 'spec_helper'

describe User do
  include DataMaker
  before do
    init_all_data
  end
  it {should belong_to(:site)}
  it {should have_many(:posts)}
  it {should validate_uniqueness_of(:site_user_id).scoped_to([:site_id])}
  it {should validate_presence_of(:site_id)}
  it {should validate_presence_of(:site_user_id)}
  # it {should validate_presence_of(:url)}
end
