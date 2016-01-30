config = require("lapis.config").get!
elasticsearch = require "elasticsearch"

interpolate_query = (clause, ...)->
  return clause

client = elasticsearch.client {
    hosts: {
        {
            protocol: config.elasticsearch.protocol or "http"
            host: config.elasticsearch.host or "127.0.0.1"
            port: config.elasticsearch.port or 9200,
        }
    }
}
{
  :interpolate_query, :client
}