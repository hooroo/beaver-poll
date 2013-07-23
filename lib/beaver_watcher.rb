# encoding utf-8
#!/usr/bin/env ruby

require_relative 'beaver_notifier'
require_relative 'beaver_build'
require_relative 'jenkins_api'
require_relative 'settings'

require 'terminal-notifier'

class BeaverWatcher
  def initialize(commit_hash)
    @commit_hash = commit_hash
  end

  def watch
    build = BeaverBuild.new(@commit_hash)
    loop do
      data = JenkinsApi.new.beaver_jobs
      result = build.result_for(data)
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
    BeaverNotifier.new.notify(status: 'FAILURE', message: @commit_hash, link: "#{web_host}/view/Beaver%20Pipeline/")
  end

  def notify_closed
    BeaverNotifier.new.notify(status: 'SUCCESS', message: @commit_hash, link: "#{web_host}/view/Beaver%20Pipeline/")
  end
end

