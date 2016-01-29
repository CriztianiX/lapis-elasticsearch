#!/bin/bash
git clone https://github.com/DhavalKapil/elasticsearch-lua
cd elasticsearch-lua
sudo luarocks make && ( cd ../ ; rm -rf elasticsearch-lua )
