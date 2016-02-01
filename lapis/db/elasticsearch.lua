local config = require("lapis.config").get()
local elasticsearch = require("elasticsearch")
local interpolate_query
interpolate_query = function(clause, ...)
  return clause
end
local client = elasticsearch.client({
  hosts = {
    {
      protocol = config.elasticsearch.protocol or "http",
      host = config.elasticsearch.host or "127.0.0.1",
      port = config.elasticsearch.port or 9200
    }
  },
  params = {
    prefered_engine = function(method, uri, params, body, timeout)
      local http = require("resty.http")
      local httpc = http.new()
      local args = {
        method = method,
        body = body,
        headers = {
          ["Content-Type"] = "application/json"
        }
      }
      local res, err = httpc:request_uri(uri, args)
      if not res then
        ngx.say("failed to request: ", err)
        return 
      end
      local response = { }
      response.code = res.status
      response.statusCode = res.status
      response.body = res.body
      return response
    end
  }
})
return {
  interpolate_query = interpolate_query,
  client = client
}
