require 'terminal-notifier'
require 'uri'
require 'net/http'
require 'pry'
require 'pp'

require 'yaml'
require 'json'

host = 'paperboy.local'
# host = 'paperboy.jqdev.net'


class Beaver
  def initialize(host)
    @host = host
  end

  def host
    "http://#{jenkins_user}:#{jenkins_token}@#{@host}"
  end

  def get_data

    # This is TOO MUCH DATA... but it should be enough to derive the build chain from.
    uri_query = "#{host}/view/Beaver/api/json"
    form = {
      "depth" => "2"
    }

    uri = URI.parse(uri_query)

    # http                = Net::HTTP.new(uri.host, uri.port)
    response            = Net::HTTP.post_form(uri, form)

    # response = http.request(request)

    json = JSON.parse(response.body)
  end

  def notify
    TerminalNotifier.notify('SUCCESS',
                            title: 'Beaver Build',
                            subtitle: 'Something',
                            group: 'Beaver Build',
                            open: "#{host}/view/Beaver%20Pipeline/")
  end

  def build_status
  end

  def close_jobs

    # this url gives you all info on a build phase
    #http://paperboy.jqdev.net/view/Beaver/job/beaver-close/api/json?depth=1&pretty=true

    # find what you want (maybe a SHA or something that can tie the beaver-prepare,beaver-model-specs...., beaver-close together
    #http://paperboy.jqdev.net/view/Beaver/job/beaver-close/api/json?depth=1&pretty=true&tree=builds[buildsByBranchName[detached[revision]]]

    # uri_query = "#{host}/view/Beaver/job/beaver-close/api/json?depth=1&tree=builds[buildsByBranchName[detached[revision]]]"

    # puts "Close uri #{uri_query}"
    data = get_data #(uri_query)
    jobs = data['jobs']

    results = jobs.map do |job|
      build = job['builds'].map do |build|
        build if build['actions'].map do |actionhash|
          actionhash if actionhash.include? 'lastBuiltRevision'
        end.compact.first['lastBuiltRevision']['SHA1'] == '9d59998e7bf7cd4b5465749994dc16a653ec7f66'
      end.compact.first

      if build
        {build['fullDisplayName'] => build['result']}
      end
    end.compact
end

  private

  def jenkins_config
    @jenkins_config ||= YAML::load File.read(ENV['HOME'] + '/.beaver.yml')
  end

  def jenkins_user
    jenkins_config['jenkins_api_user']
  end

  def sha
    "9d59998e7bf7cd4b5465749994dc16a653ec7f66"
  end

  def jenkins_token
    jenkins_config['jenkins_api_token']
  end
end

# fork do
  sleep(1)
  b = Beaver.new host
  pp b.close_jobs
  b.notify
# end


#beaver_prepare_build_number = 'http://paperboy.local/view/Beaver/api/json?depth=1&tree=jobs[name,lastBuild[number]]'
#beaver_close_with_sha = 'http://paperboy.jqdev.net/job/beaver-close/api/json?depth=1&tree=builds[actions[buildsByBranchName[detached[revision[SHA1]]]]]'

#{
#name: "beaver-prepare",
#lastBuild: {
#number: 2465
#}
#},

#http://paperboy.jqdev.net/job/beaver-close/api/json?depth=10&tree=builds[duration,actions[lastBuiltRevision,buildsByBranchName[detached[buildNumber]]]]

#http://paperboy.jqdev.net/view/Beaver/job/beaver-model-specs/api/json?tree=builds[duration,actions[lastBuiltRevision[SHA1],buildsByBranchName[detached[buildResult,buildNumber,revision]]]]

#builds: [
#{
#actions: [
#{ },
#{
#parameters: [
#{
#name: "commit",
#value: "beaver-cirode"
#}
#]
#},
#{
#causes: [
#{
#shortDescription: "Started by upstream project "beaver-acceptance-extranet" build number 1,974",
#upstreamBuild: 1974,
#upstreamProject: "beaver-acceptance-extranet",
#upstreamUrl: "job/beaver-acceptance-extranet/"
#}
#]
#},
#{
#buildsByBranchName: {
#detached: {
#buildNumber: 871,
#buildResult: null,
#revision: {
#SHA1: "f86606e920b391e6f4d17c142f81219f6df26b07",
#branch: [
#{
#SHA1: "f86606e920b391e6f4d17c142f81219f6df26b07",
#name: "detached"
#}


#http://paperboy.local/job/beaver-prepare/api/json?tree=lastBuild[number]

#http://paperboy.local/job/beaver-prepare/api/json?tree=lastBuild[number],downstreamProjects[name]

#http://paperboy.local/api/json?depth=1&tree=views[name,jobs[name,lastSuccessfulBuild[actions[causes[upstreamBuild]],number,Projects,duration,id]]]
#http://paperboy.local/api/json?depth=1&tree=views[name,jobs[name,lastBuild[actions[causes[upstreamBuild]],number,Projects,duration,id]]]

#http://paperboy.local/view/Beaver/job/beaver-prepare/api/json

#URL:http://jdunwoody:470d536b8ea9a287d9058835c5e0b8c0@paperboy.local/job/beaver-prepare/build?token=beavers
#{:parameter=>[{:name=>"GIT_BRANCH", :value=>"beaver-james"}]}
#http://paperboy.local/view/Beaver%20Pipeline/api/json?tree=jobs[name],views[name,jobs[name]]

