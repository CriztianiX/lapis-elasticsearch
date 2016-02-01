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
    @create: (values, create_opts = nil) =>
        if not create_opts or not create_opts.id
            error("Please, specify an id for your document, create_opts.id not found")
        id = create_opts.id
        doc = @get_params({ :id, body: values })
        data, res = @db.client\index(doc)
        if res == 200 or res == 201
            return @find(id)
        return data
    @delete: (primary_key) =>
        data, res = @db.client\delete @get_params({ id: primary_key })
        if res == 200
            return true
        return res        
    @find: (primary_key) =>
        data, res = @db.client\get @get_params({ id: primary_key })
        if res == 200 and data.found == true
            return @load(data._source)
        return res
    @find_all: (primary_keys) =>
        data, res = @db.client\mget @get_params({ body: { ids: primary_keys }})
        docs = {}
        if res == 200  and data.docs and next(data.docs)
            for _,doc in ipairs(data.docs)
              tinsert(docs, doc._source)
            return @load_all(docs)
        return docs
    @paginated: (...) =>
        OffsetPaginator @, ...
    @select: (query, opts = {}) =>
        params = { 
            body: {
                :query 
            } 
        }

        for k,v in pairs(opts) 
            params[k] = v

        query = @db.interpolate_query query, opts
        data, res = @db.client\search @get_params(params)

        if res == 200 
          return @load_all @parse_results(data)
        else
          return res
    --
    -- Object instance
    update: (first, ...) =>
        error("Not implemented yet")
    --
    -- Private methods

    get_params: (args = {}) =>
        --p = require("moon.all").p
        params = {
            index: @config.elasticsearch.index, type: @table_name!, body: {}
        }
        for k,v in pairs(args)
            params[k] = v
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