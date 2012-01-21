module Search::Sites
  extend ActiveSupport::Concern
  
  module ClassMethods
    def searchable
      scope :search, lambda{ |opts| do_search(opts) }
    end
    
    def do_search opts = {}
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