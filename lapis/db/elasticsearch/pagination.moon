import Paginator from require "lapis.db.pagination"
math = math
class OffsetPaginator extends Paginator
    per_page: 10
    new: (@model, clause={}, opts={}) =>
        @db = @model.__class.db
        @per_page = @model.per_page
        @per_page = opts.per_page if opts
        @_clause = @db.interpolate_query clause
        @_opts = opts
    get_page: (page) =>
        page = (math.max 1, tonumber(page) or 0) - 1
        params = { size: @per_page, from: @per_page * page }

        if next(@_opts) != nil
            for k,v in pairs(@_opts) 
                params[k] = v

        @prepare_results @select(@_clause, params)
    num_pages: =>
        math.ceil @total_items! / @per_page
    total_items: =>
      unless @_count
        @_count = @model\count @_clause
      @_count

{ :OffsetPaginator, :Paginator}