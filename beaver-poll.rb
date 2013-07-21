# encoding utf-8

require File.expand_path('../lib/beaver_watcher', __FILE__)

fork do
  b = BeaverWatcher.new ARGV.first
  b.watch
end
