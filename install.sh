#!/bin/bash
git clone https://github.com/CriztianiX/elasticsearch-lua
cd elasticsearch-lua
sudo luarocks make && cd ../ ; rm -rf elasticsearch-lua
cp -avf lapis/* /usr/local/share/lua/5.1/lapis/