#!/bin/bash
curl -XDELETE 'http://localhost:9200/twitter/'
sleep 1
curl -XPUT 'http://localhost:9200/twitter/' -d '
index :
    number_of_shards : 1
    number_of_replicas : 1
'

curl -XPUT 'http://localhost:9200/twitter/tweet/1' -d '{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}'

curl -XPUT 'http://localhost:9200/twitter/tweet/2' -d '{
    "user" : "Criztian",
    "post_date" : "2010-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}'
curl -XPUT 'http://localhost:9200/twitter/tweet/3' -d '{
    "user" : "John",
    "post_date" : "2011-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}'
echo
echo "Waiting for elasticsearch..."
sleep 1
lua "test/tmodel.lua"