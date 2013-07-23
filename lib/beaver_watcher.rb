# encoding utf-8
#!/usr/bin/env ruby

require 'beaver_notifier'
require 'beaver_build'

class BeaverWatcher
  def initialize(commit_hash)
    @build = BeaverBuild.new(commit_hash)
  end

  def watch
    loop do
      result = @build.check
      if result.is_done?
        BeaverNotifier.new.notify_failure(@build.commit_hash) if result.is_failed?
        BeaverNotifier.new.notify_closed(@build.commit_hash) if result.is_closed?
        break
      end
      sleep(20)
    end
  end
end

