module RequestClient
  def request_data(http_verb,action,parameters = {})
    send http_verb, action, parameters.merge({:format=>:json})
    tmps = ActiveSupport::JSON.decode(response.body) rescue nil
    if tmps.is_a?(Hash)
      ActiveSupport::HashWithIndifferentAccess.new tmps 
    elsif tmps.is_a?(Array)
      tmps.map{ |t| t.is_a?(Hash) ? ActiveSupport::HashWithIndifferentAccess.new(t) : t }
    end
  end
end