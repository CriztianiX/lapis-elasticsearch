local Paginator
Paginator = require("lapis.db.pagination").Paginator
local math = math
local OffsetPaginator
do
  local _parent_0 = Paginator
  local _base_0 = {
    per_page = 10,
    get_page = function(self, page)
      page = (math.max(1, tonumber(page) or 0)) - 1
      return self:prepare_results(self:select(self._clause, {
        size = self.per_page,
        from = self.per_page * page
      }))
    end,
    num_pages = function(self)
      return math.ceil(self:total_items() / self.per_page)
    end,
    total_items = function(self)
      if not (self._count) then
        self._count = self.model:count(self._clause)
      end
      return self._count
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, model, clause, ...)
      if clause == nil then
        clause = { }
      end
      self.model = model
      self.db = self.model.__class.db
      self.per_page = self.model.per_page
      if opts then
        self.per_page = opts.per_page
      end
      self._clause = self.db.interpolate_query(clause, ...)
    end,
    __base = _base_0,
    __name = "OffsetPaginator",
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
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  OffsetPaginator = _class_0
end
return {
  OffsetPaginator = OffsetPaginator,
  Paginator = Paginator
}
