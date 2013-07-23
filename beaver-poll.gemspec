Gem::Specification.new do |s|
  s.name        = 'beaver-poll'
  s.version     = '0.0.1'
  s.date        = '2013-07-23'
  s.summary     = "Beaver Success Notifier"
  s.description = "Polls for success or failure of Beaver Builds"
  s.authors     = ["Brett Wilkins"]
  s.email       = 'brett@brett.geek.nz'
  s.files       = [
                    "lib/beaver_build.rb",
                    "lib/beaver_build_result.rb",
                    "lib/beaver_host.rb",
                    "lib/beaver_notifier.rb",
                    "lib/beaver_watcher.rb",
                    "lib/jenkins_api.rb",
                    "lib/settings.rb"
                  ]
  s.executables << 'beaver-poll'
  s.homepage    = 'https://github.com/hooroo.beaver-poll'
end
