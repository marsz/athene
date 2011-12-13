module ActAsFetcher
  extend ActiveSupport::Concern
  module InstanceMethods
    def fetch url, options = {}
      method = options[:method] || "get"
      token = YAML.load_file("#{Rails.root}/config/medusa.yml")[Rails.env]["token"]
      params = {:url => url,:token=>token}
      request_url = "http://medusa.marsz.tw/crawler/fetch.json"
      params[:query] = options[:querys] if options[:querys]
      if method == 'get'
        request_url = "#{request_url}?#{params.to_query}" 
        params = nil
      end
      begin
        ActiveSupport::JSON.decode(RestClient.method(method).call(request_url, params))["data"].to_s
      rescue e
        Airbrake.notify(e, :params => {:request_url => request_url, :url => url, :options => options})
        ""
      end
    end
  end
end