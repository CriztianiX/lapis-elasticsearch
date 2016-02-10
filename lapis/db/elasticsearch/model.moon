import BaseModel from require "lapis.db.base_model"
import OffsetPaginator from require "lapis.db.elasticsearch.pagination"
tinsert = table.insert

class Model extends BaseModel
    @config = require("lapis.config").get!
    @db = require "lapis.db.elasticsearch"
    -- Class methods
    @count: (query) =>
        data, res = @db.client\count @get_params( { body: { :query } })
        if res == 200
            return data.count
        return res
    @delete: (primary_key) =>
        data, res = @db.client\delete @get_params({ id: primary_key })
        if res == 200
            return true
        return res
    @find: (primary_key) =>
        data, res = @db.client\get @get_params({ id: primary_key })
        if res == 200 and data.found == true
            -- append id to source
            data._source.id = primary_key
            return @load(data._source)
        return res
    @paginated: (...) =>
        OffsetPaginator @, ...
    @select: (query, opts={}) =>
        params = { 
            body: {
                :query
            }
        }

        data, res = @db.client\search @get_params(params, opts)

        if res == 200 
          return @load_all @parse_results(data)
        else
          return res
    --
    -- Object instance
    update: (first, ...) =>
        if not first
            error("data for update is missing")

        primary = @_primary_cond!
        if not primary or not primary.id
            error("primary key id not found")

        params = @get_params({ id: primary.id, body: { doc: first } })
        return @@db.client\update params
    --
    -- Private methods

    get_params: (args={}, opts={}) =>
        --p = require("moon.all").p
        params = {
            index: @@config.elasticsearch.index
            type: @@table_name!
            body: {}
        }

        for k,v in pairs(args)
            params[k] = v
        for k,v in pairs(opts)
            params.body[k] = v
        
        if next(params.body)
            params.body = params.body
        else
            params.body = nil
        --p(params)
        return params
    parse_results: (results) =>
      hits = {}
      if results.hits and results.hits.hits
        for _,hit in ipairs(results.hits.hits)
          tinsert(hits, hit._source)
      return hits
{ :Model }