class BeaverBuildResult
  def initialize(result)
    @result = result
  end

  def is_done?
    is_failed? || is_closed?
  end

  def is_failed?
    @result.reduce(false) do |state, res|
      state || res['result'] == 'FAILURE'
    end
  end

  def is_closed?
    @result.reduce(false) do |state, res|
      state || ( !res['build_step'].index('beaver-close').nil? && res['result'] == 'SUCCESS' )
    end
  end
end
