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
      host = config.elasticsearch.host or "localhost",
      port = config.elasticsearch.port or 9200
    }
  }
})
return {
  interpolate_query = interpolate_query,
  client = client
}
