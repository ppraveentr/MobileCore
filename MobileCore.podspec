#
# Be sure to run `pod lib lint MobileCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MobileCore'
  s.version          = '0.0.5.1'
  s.summary          = 'Shared utility.'
  #s.description      = <<-DESC

  s.homepage         = 'https://github.com/ppraveentr/MobileCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PraveenP' => 'ppraveentr@gmail.com' }
  s.source           = { :git => 'https://github.com/ppraveentr/MobileCore.git', :tag => s.version.to_s }
  s.frameworks 		 = 'UIKit'
  
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  
  s.default_subspecs = 'FTCoreUtility', 'FTMobileCore', 'FTMobileCoreUI'

  s.subspec 'FTCoreUtility' do |utility|
    utility.source_files = 'MobileCore/FTCoreUtility/FTCoreUtility/**/*.swift'
  end

  s.subspec 'FTMobileCore' do |mobileCore|
    mobileCore.source_files = 'MobileCore/FTMobileCore/FTMobileCore/**/*.swift'
    mobileCore.dependency  'MobileCore/FTCoreUtility'
  end

  s.subspec 'FTMobileCoreUI' do |mobileCoreUI|
    mobileCoreUI.source_files = 'MobileCore/FTMobileCoreUI/FTMobileCoreUI/**/*.swift'
    mobileCoreUI.resources = ['MobileCore/FTMobileCoreUI/FTMobileCoreUIBundle/Resources/**/*',
                      			    'MobileCore/FTMobileCoreUI/FTMobileCoreUI/**/*.xib']
    mobileCoreUI.dependency  'MobileCore/FTCoreUtility'
  end
  
end
