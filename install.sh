#!/bin/bash
git clone https://github.com/DhavalKapil/elasticsearch-lua
cd elasticsearch-lua
sudo luarocks make && rm -rf elasticsearch-lua
