module Search::Sites
  extend ActiveSupport::Concern

  include Search::Base
  
  module ClassMethods
    
    protected
    
    def do_search_by opts = {}
      sites = Site.scoped
      if opts[:site]
        site = Site.find_by_domain(opts[:site].to_s.downcase)
        sites = sites.where(:id => site ? site.id : 0)
      end
      sites
    end
  end

  module InstanceMethods
    def to_api_hash
      { :id => id, :name => name, :domain => domain }
    end
  end
end