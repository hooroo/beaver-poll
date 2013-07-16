require 'terminal-notifier'
require 'uri'
require 'net/http'

require 'yaml'
require 'json'

host = 'paperboy.local'
# host = 'paperboy.jqdev.net'


class Beaver
  def initialize(host)
    @host = host
  end

  def host
    "http://#{jenkins_config['jenkins_api_user']}:#{jenkins_config['jenkins_api_token']}@#{@host}"
  end

  def get_json(query = nil)

    uri_query = "#{host}/view/Beaver/api/json"
    form = {
      "depth" => "2"
    }

    # uri_query = "#{host}api/json?depth=1&tree=views[name,jobs[name,lastSuccessfulBuild[actions[causes[upstreamBuild]],number,Projects,duration,id]]]"

    # api_url = @url

    uri = URI.parse(uri_query)

    http                = Net::HTTP.new(uri.host, uri.port)
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
    get_json#(uri_query)
  end

  def jenkins_config
    @jenkins_config ||= YAML::load File.read(ENV['HOME'] + '/.beaver.yml')
  end
end

fork do
  sleep(1)
  b = Beaver.new host
  p b.get_json
  b.notify
end


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

