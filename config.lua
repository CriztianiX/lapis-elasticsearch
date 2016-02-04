local config = require("lapis.config")

config({ "development", "testing", "production", "test"}, {
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