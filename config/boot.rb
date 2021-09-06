ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
ENV["MONGODB_URI"] = "mongodb://iad2-c16-1.mongo.objectrocket.com:52946,iad2-c16-2.mongo.objectrocket.com:52946,iad2-c16-0.mongo.objectrocket.com:52946/?replicaSet=0d3fd1ed15144b16a3c518c7a838ce74&ssl=true"

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
