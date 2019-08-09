#
# Be sure to run `pod lib lint MobileCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MobileCore'
  s.version          = '0.0.1'
  s.summary          = 'Shared utility.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  #s.description      = <<-DESC

  s.homepage         = 'https://github.com/ppraveentr/MobileCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PraveenP' => 'ppraveentr@gmail.com' }
  s.source           = { :git => 'https://github.com/ppraveentr/MobileCore.git', :tag => s.version.to_s }
  s.frameworks 		 = 'UIKit'
  
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.default_subspecs = 'FTCoreUtility', 'FTMobileCore', 'FTMobileCoreUI'

  s.subspec 'FTCoreUtility' do |coreUtility|
      coreUtility.source_files = 'FTCoreUtility/FTCoreUtility/**/*'
  end
  
  s.subspec 'FTMobileCore' do |mobileCore|
      mobileCore.source_files = 'FTMobileCore/FTMobileCore/**/*'
      mobileCore.dependency 'MobileCore/FTCoreUtility'
  end
  
  s.subspec 'FTMobileCoreUI' do |mobileCoreUI|
  	  mobileCoreUI.source_files = 'FTMobileCoreUI/FTMobileCoreUI/**/*'
      mobileCoreUI.dependency 'MobileCore/FTCoreUtility'
  	  #mobileCoreUI.resource_bundle = {'FTMobileCoreUI' => 'FTMobileCoreUI/FTMobileCoreUI/Resources/**/*.{xcassets,storyboard}'}
  end

end
