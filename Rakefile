task :default => :build

task :build do
  `rm wsserver.gem`
  `gem build wsserver`
  `mv wsserver-*.gem wsserver.gem`
end
