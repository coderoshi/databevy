# Place your Database config here

riak = require 'riak-js'
riak_config = SS.config.db.riak
global.Riak = riak.getClient
  host: riak_config.host
  port: riak_config.port
  # api: 'protobuf'  # still experimental...

# neo4j = require 'neo4j'
# global.Neo4j = new neo4j.GraphDatabase(riak_config.url)

