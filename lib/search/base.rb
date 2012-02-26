module Search::Base
  extend ActiveSupport::Concern
  
  module ClassMethods
    def acts_as_searchable
      scope :meta_search, lambda {|opts| do_meta_search(opts) }
      scope :search_scoped, lambda { |opts| do_search_scoped(opts) }
      scope :search_by, lambda { |opts| do_search_by(opts) }
    end
    
    protected

    def do_meta_search opts = {}
      s = search_scoped(opts).search_by(opts) 
      s = s.where(:id => search_by(opts).select(:id).search(opts[:search]).all.map{|o|o.id}) if opts[:search].is_a?(Hash) && opts[:search].keys.size > 0
      s
    end
    def do_search_scoped opts = {}
      # paginates_per 50
      self.scoped
    end

    def do_search_by opts = {}
      self.scoped
    end
  end

  module InstanceMethods
    def to_api_hash
      ActiveSupport::HashWithIndifferentAccess.new self.attributes
    end
  end
end