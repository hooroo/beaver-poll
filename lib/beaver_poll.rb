#!/usr/bin/env ruby
# encoding utf-8

require 'beaver_watcher'

fork do
  b = BeaverWatcher.new ARGV.first
  b.watch
end
