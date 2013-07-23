require 'yaml'
require_relative 'beaver_host'

class Settings
  def initialize
    @settings = YAML::load File.read(ENV['HOME'] + '/.beaver.yml')
  end

  def jenkins_user
    @settings['jenkins_api_user']
  end

  def jenkins_token
    @settings['jenkins_api_token']
  end

  def host
    @settings['jenkins_api_host'] ||= BeaverHost.pick('paperboy.local', 'paperboy.jqdev.net')
  end
end
