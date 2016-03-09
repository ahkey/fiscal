ENV['RACK_ENV'] = 'test'
require_relative "../env.rb"
Bundler.require :test
