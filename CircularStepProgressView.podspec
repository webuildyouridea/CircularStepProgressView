Pod::Spec.new do |s|
  s.name             = 'CircularStepProgressView'
  s.version          = '1.02'
  s.summary          = 'Circular Progress View with Steps'
 
  s.description      = <<-DESC
This progress view allows you to mark a progress into a circular line with N steps between the start and the end!
                       DESC
 
  s.homepage         = 'https://github.com/webuildyouridea/CircularStepProgressView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arpad Larrinaga' => 'arpad@muub.com' }
  s.source           = { :git => 'https://github.com/webuildyouridea/CircularStepProgressView.git', :tag => 'v1.02' }
 
  s.ios.deployment_target = '8.3'
  s.source_files = 'CircularStepProgressView/CircularStepProgressView.swift'
  s.dependency 'pop', '~> 1.0'
 
end
