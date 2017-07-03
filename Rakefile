task :default => "build"

desc "Install Pod Dependencies"
task :install_deps do
	sh "pod install"
end

desc "Clean up derived data and pods"
task :clean do
	sh "rm -rf ~/Library/Developer/Xcode/DerivedData/KickStarterRxSwift*"
	sh "rm -rf Pods"
end

desc "Synchronize xcode groups & folders"
task :synx do 
	sh "synx ./KickStarterRxSwift.xcodeproj"
end

desc "Build project WorkSpace"
task :build => ["clean", "synx", "install_deps"] do 
end

