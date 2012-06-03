module ActAsFetcher
  extend ActiveSupport::Concern
  module InstanceMethods
    
    def download url, options = {}
      download_through_medusa(url, options)
    end
    
    def fetch url, options = {}
      fetch_through_medusa(url,options)["data"].to_s
    end
    
    def fetch_status url, options = {}
      fetch_through_medusa(url,options)["status"]
    end
    
    private
    
    def medusa_token
      YAML.load_file("#{Rails.root}/config/medusa.yml")[Rails.env]["token"]
    end
    def fetch_through_medusa url, options = {}
      method = options[:method] || "get"
      params = {:url => url,:token => medusa_token}
      request_url = "http://medusa.marsz.tw/crawler/fetch.json"
      params[:query] = options[:querys] if options[:querys]
      if method == 'get'
        request_url = "#{request_url}?#{params.to_query}" 
        params = nil
      end
      begin
        ActiveSupport::JSON.decode(RestClient.method(method).call(request_url, params))
      rescue => e
        ""
      end
    end
    
    def download_through_medusa url, options = {}
      params = { :url => url, :token => medusa_token }
      params[:referer] = options[:referer] if options[:referer]
      request_url = "http://medusa.marsz.tw/crawler/download.json"
      ActiveSupport::HashWithIndifferentAccess.new(ActiveSupport::JSON.decode(RestClient.post(request_url, params)))
    end
  end
end