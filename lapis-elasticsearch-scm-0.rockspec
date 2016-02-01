package = "lapis-elasticsearch"
version = "scm-0"
source = {
  url = "git://github.com/CriztianiX/lapis-elasticsearch",
}
description = {
  summary = "Elasticsearch model support for lapis framework",
  detailed = [[
    Elasticsearch model support for lapis framework.
    Under development.
  ]],
  homepage = "https://github.com/CriztianiX/lapis-elasticsearch",
  license = "Apache 2"
}
dependencies = {
  "lua >= 5.1, < 5.4",
  "lapis",
  "lua-resty-http"
}
build = {
  type = "command",
  install_command = "./install.sh"
}
