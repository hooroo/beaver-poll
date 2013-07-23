# encoding utf-8
#!/usr/bin/env ruby

require_relative 'beaver_notifier'
require_relative 'beaver_build'
require_relative 'settings'

require 'terminal-notifier'
require 'uri'
require 'net/http'

require 'json'

class BeaverWatcher
  def initialize(commit_hash)
    @commit_hash = commit_hash
  end

  def watch
    build = BeaverBuild.new(@commit_hash)
    loop do
      data = get_data
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

  def get_data
    uri_query = "#{api_host}/view/Beaver/api/json"
    form = {
      "tree" => "jobs[builds[fullDisplayName,result,actions[lastBuiltRevision[SHA1]]]]"
    }

    uri      = URI.parse(uri_query)
    response = Net::HTTP.post_form(uri, form)

    JSON.parse(response.body)
  end

  def api_host
    "http://#{settings.jenkins_user}:#{settings.jenkins_token}@#{settings.host}"
  end

  def web_host
    "http://#{settings.host}"
  end

  def settings
    @settings = Settings.new
  end

  def notify_failure
    BeaverNotifier.new.notify(status: 'FAILURE', message: @commit_hash, link: "#{web_host}/view/Beaver%20Pipeline/")
  end

  def notify_closed
    BeaverNotifier.new.notify(status: 'SUCCESS', message: @commit_hash, link: "#{web_host}/view/Beaver%20Pipeline/")
  end
end

