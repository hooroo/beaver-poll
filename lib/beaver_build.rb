require_relative('jenkins_api')
require_relative('beaver_build_result')

class BeaverBuild
  attr_reader :commit_hash

  def initialize(commit_hash)
    @commit_hash = commit_hash
    @api = JenkinsApi.new
  end

  def check
    BeaverBuildResult.new(process_beavers)
  end

  private

  def process_beavers
    @api.beaver_jobs['jobs'].map do |job|
      process_job job
    end.compact
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
end
