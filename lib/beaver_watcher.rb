# encoding utf-8
#!/usr/bin/env ruby

require_relative 'beaver_notifier'
require_relative 'beaver_build'
require_relative 'settings'

require 'terminal-notifier'

class BeaverWatcher
  def initialize(commit_hash)
    @build = BeaverBuild.new(commit_hash)
  end

  def watch
    loop do
      result = @build.check
      if result.is_done?
        notify_failure if result.is_failed?
        notify_closed if result.is_closed?
        break
      end
      sleep(20)
    end
  end

  private

  def settings
    @settings = Settings.new
  end

  def web_host
    "http://#{settings.host}"
  end

  def notify_failure
    BeaverNotifier.new.notify(status: 'FAILURE', message: @build.commit_hash, link: "#{web_host}/view/Beaver%20Pipeline/")
  end

  def notify_closed
    BeaverNotifier.new.notify(status: 'SUCCESS', message: @build.commit_hash, link: "#{web_host}/view/Beaver%20Pipeline/")
  end
end

