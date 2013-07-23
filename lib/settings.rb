require 'yaml'

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
    'paperboy.local'
    # @host = 'paperboy.jqdev.net'
  end
end
