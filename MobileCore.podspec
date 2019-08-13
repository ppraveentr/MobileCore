#
# Be sure to run `pod lib lint MobileCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MobileCore'
  s.version          = '0.0.3.4'
  s.summary          = 'Shared utility.'
  #s.description      = <<-DESC

  s.homepage         = 'https://github.com/ppraveentr/MobileCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PraveenP' => 'ppraveentr@gmail.com' }
  s.source           = { :git => 'https://github.com/ppraveentr/MobileCore.git', :tag => s.version.to_s }
  s.frameworks 		 = 'UIKit'
  
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.ios.vendored_frameworks = 'buildFramework/FTMobileCore.framework', 'buildFramework/FTCoreUtility.framework', 'buildFramework/FTMobileCoreUI.framework'

end
