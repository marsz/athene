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
  it {should validate_format_of(:domain).with(/[a-z\-]+/)}
end
