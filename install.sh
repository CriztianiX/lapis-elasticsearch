#!/bin/bash
git clone https://github.com/CriztianiX/elasticsearch-lua
cd elasticsearch-lua
sudo luarocks make && ( cd ../ ; rm -rf elasticsearch-lua )
