config = require("lapis.config").get!
elasticsearch = require "elasticsearch"
tinsert = table.insert

interpolate_query = (clause, ...)->
  return clause

parse_hosts_config = (hosts) ->
    servers = {}
    for _, host in ipairs(hosts)
        h = {
            protocol: host.protocol or "http"
            host: host.host or "127.0.0.1"
            port: host.port or 9200
        }
        tinsert servers, h
    servers

client = elasticsearch.client {
    hosts: config.elasticsearch.hosts and parse_hosts_config(config.elasticsearch.hosts) or {
        {
            protocol: "http"
            host: "127.0.0.1"
            port: 9200
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