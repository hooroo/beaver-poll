# encoding utf-8
#!/usr/bin/env ruby

require_relative 'beaver_notifier'

require 'terminal-notifier'
require 'uri'
require 'net/http'

require 'yaml'
require 'json'

class BeaverWatcher
  def initialize(commit_hash)
    #@host = 'paperboy.local'
    @host = 'paperboy.jqdev.net'
    @commit_hash = commit_hash
  end

  def watch
    loop do
      data = get_data
      results = process_data(data)
      if is_done?(results)
        notify_failure if is_failed?(results)
        notify_closed if is_closed?(results)
        break
      end
      binding.pry
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

  def process_data(data)
    jobs = data['jobs']

    jobs.map do |job|
      process_job job
    end.compact
  end

  def is_done?(results)
    is_failed?(results) || is_closed?(results)
  end

  def is_failed? (results)
    results.reduce(false) do |state, res|
      state || res['result'] == 'FAILURE'
    end
  end

  def is_closed?(results)
    results.reduce(false) do |state, res|
      state || ( !res['build_step'].index('beaver-close').nil? && res['result'] == 'SUCCESS' )
    end
  end

  def api_host
    "http://#{jenkins_user}:#{jenkins_token}@#{@host}"
  end

  def web_host
    "http://#{@host}"
  end

  def process_job(job)
    build = job['builds'].map do |build|
      process_build(build)
    end.compact.first

    if build
      {
        "build_step" => build['fullDisplayName'],
        "result" => build['result']
      }
    end
  end

  def process_build(build)
    actions = build['actions'].map do |actionhash|
      actionhash if actionhash.include? 'lastBuiltRevision'
    end.compact.first

    if actions && actions['lastBuiltRevision']['SHA1'] == @commit_hash
      build
    end
  end

  def jenkins_config
    @jenkins_config ||= YAML::load File.read(ENV['HOME'] + '/.beaver.yml')
  end

  def jenkins_user
    jenkins_config['jenkins_api_user']
  end

  def jenkins_token
    jenkins_config['jenkins_api_token']
  end

  def notify_failure
    BeaverNotifier.new.notify(status: 'FAILURE', message: @commit_hash, link: "#{web_host}/view/Beaver%20Pipeline/")
  end

  def notify_closed
    BeaverNotifier.new.notify(status: 'SUCCESS', message: @commit_hash, link: "#{web_host}/view/Beaver%20Pipeline/")
  end
end

