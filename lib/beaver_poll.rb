#!/usr/bin/env ruby
# encoding utf-8

require 'beaver_watcher'

b = BeaverWatcher.new ARGV.first
b.watch
