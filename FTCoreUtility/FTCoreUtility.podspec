#
#  Be sure to run `pod spec lint FTCoreUtility.podspec' to ensure this is a
#

Pod::Spec.new do |s|

  s.name         = "FTCoreUtility"
  s.version      = "0.0.1"
  s.summary      = "Shared utility."

  #s.description  = <<-DESC DESC


  s.homepage     = "https://github.com/ppraveentr/MobileCore"
  s.license      = "MIT"
  s.author       = { "PraveenP" => "ppraveentr@gmail.com" }
  s.source       = { :http => 'https://github.com/ppraveentr/MobileCore/tree/dev/PraveenP/MobileCodePodCreation/ftCoreUtility.git' }
  s.frameworks = "Foundation", "UIKit"

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.default_subspecs = 'AppBase', 'ClassReflection', 'Extensions', 'Generic', 'KeychainWrapper', 'Logger', 'Theme', 'View'
  
  s.subspec 'AppBase' do |appBase|
      appBase.source_files = 'FTCoreUtility/AppBase/**/*'
  end
  
  s.subspec 'ClassReflection' do |classReflection|
      classReflection.source_files = 'FTCoreUtility/ClassReflection/**/*'
  end
  
  s.subspec 'Extensions' do |extensions|
      extensions.source_files = 'FTCoreUtility/Extensions/**/*'
  end
  
  s.subspec 'Theme' do |theme|
      theme.source_files = 'FTCoreUtility/Theme/**/*'
	  theme.dependency 'FTCoreUtility/ClassReflection'
	  theme.dependency 'FTCoreUtility/Extensions'
  end
  
  s.subspec 'Generic' do |generic|
      generic.source_files = 'FTCoreUtility/Generic/**/*'
      generic.dependency 'FTCoreUtility/Theme'
  end
  
  s.subspec 'KeychainWrapper' do |keychainWrapper|
      keychainWrapper.source_files = 'FTCoreUtility/KeychainWrapper/**/*'
  end
  
  s.subspec 'Logger' do |logger|
      logger.source_files = 'FTCoreUtility/Logger/**/*'
  end
  
  s.subspec 'View' do |view|
      view.source_files = 'FTCoreUtility/View/**/*'
  end
  
end
