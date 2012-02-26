module Restable
  def should_match_querys klass, querys = {}
    search_results(querys).map{|p|p[:id]}.should == klass.meta_search(querys).map{|o|o.id}
  end
  def search opts = {}
    action = opts[:action] || :index
    get action, opts.merge(:format => :json)
    ActiveSupport::HashWithIndifferentAccess.new ActiveSupport::JSON.decode(response.body)
  end
end