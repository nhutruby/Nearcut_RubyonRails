ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
ENV["MONGODB_URI"] = 'mongodb+srv://abc:abcdafawwefwea@cluster0.oowhr.mongodb.net/nearcut?retryWrites=true&w=majority'
require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
