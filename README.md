# lapis-elasticsearch - elasticsearch support for lapis

### Models <br/>
Provides a Model base class for making Lua tables that can be synchronized with elasticsearch type. 
#### The most primitive model is a blank model:

```lua
local Model = require("lapis.db.elasticsearch.model").Model
local Tweets = Model:extend("tweet", {
  per_page = 2
})
```
```
The first argument to extend is the name of the type to associate the model to. 
```

### Model:find(id)
```lua
local tweet = Tweets:find(1)
```
```
The find class method fetches a single row from the table by id. 
```

### Model:find_all(ids)
```lua
local tweets = Tweets:find_all({1,2,3})
```

### Model:select(query, ...)
```lua
local query = {
  match_all = {}
}
local tweet = Tweets:select(query)
local paginated = Tweets:paginated(query)
paginated:total_items()
paginated:num_pages()
paginated:get_page(2)
```
### Model:delete(id)
```lua
local res = Tweets:delete(1)
```
```
res will be true on success delete
```
