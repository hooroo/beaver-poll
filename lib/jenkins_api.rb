require 'uri'
require 'net/http'
require 'json'

require_relative 'settings'

class JenkinsApi
  def initialize
  end

  def beaver_jobs
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

  def settings
    @settings ||= Settings.new
  end
end
