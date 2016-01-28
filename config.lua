local config = require("lapis.config")

config({ "development", "testing", "production", "test"}, {
    elasticsearch = {
        protocol = "http",
        index = "twitter"
    }
})