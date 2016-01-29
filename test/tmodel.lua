local assert = require("luassert")
local p = require "moon.all".p
local Model = require("lapis.db.elasticsearch.model").Model
local Tweets = Model:extend("tweet", {
  per_page = 2
})

local query = {
  match_all = {}
}

local tweet = Tweets:find(1)
assert.are.equal(tweet.user, "kimchy")

local tweets = Tweets:select(query)
assert.are.equal(table.getn(tweets), 3)

assert.are.equal(Tweets:count(), 3)

local paginated = Tweets:paginated(query)

assert.are.equal(paginated:total_items(), 3)
assert.are.equal(paginated:num_pages(), 2)

local page = paginated:get_page(2)
assert.are.equal(page[1].user, "John")

