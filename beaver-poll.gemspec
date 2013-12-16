Gem::Specification.new do |s|
  s.name        = 'beaver-poll'
  s.version     = '0.0.3'
  s.date        = '2013-07-23'
  s.summary     = "Beaver Success Notifier"
  s.description = "Polls for success or failure of Beaver Builds"
  s.authors     = ["Brett Wilkins", "James Dunwoody"]
  s.email       = ['brett@brett.geek.nz', 'jamesdunwoody@gmail.com']
  s.files       = [
                    "lib/beaver_build.rb",
                    "lib/beaver_build_result.rb",
                    "lib/beaver_host.rb",
                    "lib/beaver_notifier.rb",
                    "lib/beaver_poll.rb",
                    "lib/beaver_watcher.rb",
                    "lib/jenkins_api.rb",
                    "lib/settings.rb"
                  ]
  s.executables << 'beaver-poll'
  s.homepage    = 'https://github.com/hooroo/beaver-poll'

  s.add_dependency('terminal-notifier', '~>1.4.2')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('pry')
  s.add_development_dependency('pry-debugger')
end
