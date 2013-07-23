

class BeaverBuild
  def initialize(commit_hash)
    @commit_hash = commit_hash
  end

  def process_data(data)
    jobs = data['jobs']

    return jobs.map do |job|
      process_job job
    end.compact
  end

  # private

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
end
