local BaseModel
BaseModel = require("lapis.db.base_model").BaseModel
local OffsetPaginator
OffsetPaginator = require("lapis.db.elasticsearch.pagination").OffsetPaginator
local tinsert = table.insert
local Model
do
  local _parent_0 = BaseModel
  local _base_0 = {
    update = function(self, first, ...)
      if not first then
        error("data for update is missing")
      end
      local primary = self:_primary_cond()
      if not primary or not primary.id then
        error("primary key id not found")
      end
      local params = self:get_params({
        id = primary.id,
        body = {
          doc = first
        }
      })
      return self.__class.db.client:update(params)
    end,
    get_params = function(self, args, opts)
      if args == nil then
        args = { }
      end
      if opts == nil then
        opts = { }
      end
      local params = {
        index = self.__class.config.elasticsearch.index,
        type = self.__class:table_name(),
        body = { }
      }
      for k, v in pairs(args) do
        params[k] = v
      end
      for k, v in pairs(opts) do
        params.body[k] = v
      end
      if not next(params.body) then
        params.body = nil
      end
      return params
    end,
    parse_results = function(self, results)
      local hits = { }
      if results.hits and results.hits.hits then
        for _, hit in ipairs(results.hits.hits) do
          tinsert(hits, hit._source)
        end
      end
      return hits
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, ...)
      return _parent_0.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Model",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.config = require("lapis.config").get()
  self.db = require("lapis.db.elasticsearch")
  self.count = function(self, query)
    local data, res = self.db.client:count(self:get_params({
      body = {
        query = query
      }
    }))
    if res == 200 then
      return tonumber(data.count)
    end
    return res
  end
  self.delete = function(self, primary_key)
    local data, res = self.db.client:delete(self:get_params({
      id = primary_key
    }))
    if res == 200 then
      return true
    end
    return res
  end
  self.find = function(self, primary_key)
    local data, res = self.db.client:get(self:get_params({
      id = primary_key
    }))
    if res == 200 and data.found == true then
      data._source.id = primary_key
      return self:load(data._source)
    end
    return res
  end
  self.paginated = function(self, ...)
    return OffsetPaginator(self, ...)
  end
  self.aggs = function(self, query, aggs)
    local params = {
      fields = "aggregations",
      size = 1,
      body = {
        query = query,
        aggs = aggs
      }
    }
    local aggregations = self:query(params)
    return aggregations.aggregations
  end
  self.query = function(self, params)
    params = self:get_params(params)
    local data, res = self.db.client:search(params)
    if res == 200 then
      return data
    else
      return error(res)
    end
  end
  self.select = function(self, query, opts)
    if opts == nil then
      opts = { }
    end
    local params = {
      body = {
        query = query
      }
    }
    local data, res = self.db.client:search(self:get_params(params, opts))
    if res == 200 then
      return self:load_all(self:parse_results(data))
    else
      return error(res)
    end
  end
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Model = _class_0
end
return {
  Model = Model
}
