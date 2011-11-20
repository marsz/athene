class Crawlers
  def self.seed_sites
    [:wretch]
  end
  def self.subclasses
    seed_sites.map{|name| "Crawlers::#{name.to_s.camelize}".constantize}
  end
end