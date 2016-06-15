import BaseModel from require "lapis.db.base_model"
import OffsetPaginator from require "lapis.db.elasticsearch.pagination"
tinsert = table.insert

class Model extends BaseModel
    @config = require("lapis.config").get!
    @db = require "lapis.db.elasticsearch"
    -- Class methods
    @create: (values, create_opts = nil) =>
        if not create_opts or not create_opts.id
            error("Please, specify an id for your document,create_opts.id not found")
        id = create_opts.id
        parent = tostring(create_opts.parent) or nil
        doc = @get_params :parent, :id, body: values
        data, res = @db.client\index(doc)
        if res == 200 or res == 201
            return @find(id)
        return data
    @count: (query) =>
        data, res = @db.client\count @get_params( { body: { :query } })
        if res == 200
            return tonumber(data.count)
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
    @aggs: (query, aggs) =>
        params = {
            fields: "aggregations"
            size: 1
            body: { :query, :aggs }
        }
        aggregations = @query(params)
        aggregations.aggregations
    @query: (params) =>
        params = @get_params(params)
        data, res = @db.client\search params
        if res == 200
          return data
        else
          return error(res)
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
          return error(res)
    @index_name: =>
        @@config.elasticsearch.index
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
        index = @@index_name!
        params = index: index, type: @@table_name!, body: {}
        for k,v in pairs(args)
            params[k] = v
        for k,v in pairs(opts)
            params.body[k] = v
        if not next(params.body)
            params.body = nil
        return params
    parse_results: (results) =>
      hits = {}
      if results.hits and results.hits.hits
        for _,hit in ipairs(results.hits.hits)
          tinsert(hits, hit._source)
      return hits
{ :Model }