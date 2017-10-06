Pod::Spec.new do |s|
  s.name             = 'Finite'
  s.version          = '3.0.3'
  s.summary          = 'A simple state machine written in Swift.'
  s.description      = <<-DESC
Finite is a simple, pure Swift finite state machine.
                       DESC
  s.social_media_url = "https://twitter.com/vknabel"
  s.homepage         = 'https://github.com/vknabel/Finite'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Valentin Knabel' => 'dev@vknabel.com' }
  s.source           = { :git => 'https://github.com/vknabel/Finite.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
	s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source_files = 'Sources/*.swift'
end
