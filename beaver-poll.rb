# encoding utf-8

require_relative 'lib/beaver_watcher'

fork do
  b = BeaverWatcher.new ARGV.first
  b.watch
end
