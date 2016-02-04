local config = require("lapis.config").get()
local elasticsearch = require("elasticsearch")
local tinsert = table.insert
local interpolate_query
interpolate_query = function(clause, ...)
  return clause
end
local parse_hosts_config
parse_hosts_config = function(hosts)
  local servers = { }
  for _, host in ipairs(hosts) do
    local h = {
      protocol = host.protocol or "http",
      host = host.host or "127.0.0.1",
      port = host.port or 9200
    }
    tinsert(servers, h)
  end
  return servers
end
local p = require("moon.all").p
p(config.elasticsearch.hosts)
local client = elasticsearch.client({
  hosts = config.elasticsearch.hosts and parse_hosts_config(config.elasticsearch.hosts) or {
    {
      protocol = "http",
      host = "127.0.0.1",
      port = 9200
    }
  },
  params = {
    preferred_engine = function(method, uri, params, body, timeout)
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
