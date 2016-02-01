config = require("lapis.config").get!
elasticsearch = require "elasticsearch"

interpolate_query = (clause, ...)->
  return clause

client = elasticsearch.client {
    hosts: {
        {
            protocol: config.elasticsearch.protocol or "http"
            host: config.elasticsearch.host or "127.0.0.1"
            port: config.elasticsearch.port or 9200
        }
    },
    params: {
        -- Should return a table with { status, statusCode, body }
        preferred_engine: (method, uri, params, body, timeout) ->
            http = require "resty.http"
            httpc = http.new!
            args = { :method, :body, headers: { ["Content-Type"]: "application/json" } }
            res, err = httpc\request_uri(uri, args)

            if not res
                ngx.say("failed to request: ", err)
                return

            response = {}
            response.code = res.status
            response.statusCode = res.status
            response.body = res.body
            return response
    }
}
{
  :interpolate_query, :client
}