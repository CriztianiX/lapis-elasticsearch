# lapis-elasticsearch - elasticsearch support for lapis

### Config <br />
Add an elasticserrch key in your config like this:
```lua
config({ "development"}, {
    elasticsearch = {
        index = "twitter",
        hosts = {
            {
                protocol = "http",
                port = 9200,
                host = "127.0.0.1"
            }
        }
    }
})
```

## Models <br/>
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
### Model:create(values, create_opts = nil) - The create class method is used to create new docs. It takes a table of column values to create the docs with. It returns an instance of the model.
```lua
local tweet = Tweets:create({
  name  = "Criztian Haunsen"
}, { id = "my_id"})
```

### Model:count(query) - Counts the number of records in the table that match the clause.
```lua
local tweet = Tweets:count()
local tweet = Tweets:count({
  match_all = {}
})
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
```
### Model:find_all(ids)
```lua
local tweets = Tweets:find_all({1,2,3})
```

### Model:table_name() - Returns the name of the table backed by the model.
```lua
local tweet = Tweets:table_name()
```

### Model:delete(id)
```lua
local res = Tweets:delete(1)
```
```
res will be true on success delete
```

## Instance Methods
### obj:update(fields = {}) - Instances of models have the update method for updating the row. The values of the primary keys are used to uniquely identify the row for updating.
```lua
tweet:update({
  author = "Peter"
})
```

## Pagination <br />
We can create a paginator like so:
```lua
local query = {
  match_all = {}
}
local paginated = Tweets:paginated(query)
```
#### Gets the total number of items that can be returned. 
```lua
paginated:total_items()
```
#### Returns the total number of pages.
```lua
paginated:num_pages()
```
#### Gets page_num, where pages are 1 indexed
```lua
paginated:get_page(2)
```
