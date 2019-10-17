Pod::Spec.new do |s|
  s.name             = 'MobileCore'
  s.version          = '0.0.7.2'
  s.summary          = 'Mobile Core utility.'
  s.homepage         = 'https://github.com/ppraveentr/MobileCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PraveenP' => 'ppraveentr@gmail.com' }
  s.source           = { :git => 'https://github.com/ppraveentr/MobileCore.git', :tag => s.version.to_s }
  s.weak_framework 	 = 'UIKit'

  s.ios.deployment_target = '9.0'
  s.swift_version         = '5.0'
  s.default_subspecs      = 'CoreUtility', 'Core', 'CoreUI'

  s.subspec 'CoreUtility' do |utility|
    utility.source_files  = 'FTCoreUtility/Classes/**/*.{h,m,swift}'
    utility.header_dir    = "CoreUtility"
  end

  s.subspec 'Core' do |core|
    core.source_files   = 'FTMobileCore/Classes/**/*.{h,m,swift}'
    core.dependency  'MobileCore/CoreUtility'
    core.header_dir    = "Core"
  end

  s.subspec 'CoreUI' do |coreUI|
    coreUI.source_files = 'FTMobileCoreUI/Classes/**/*.{h,m,swift}'
    coreUI.resources    = ['FTMobileCoreUI/Assets/**/*', 'FTMobileCoreUI/Classes/**/*.xib']
    coreUI.dependency  'MobileCore/CoreUtility'
    coreUI.header_dir   = "CoreUI"
  end
  
   s.subspec 'Testing' do |testing|
      testing.source_files = 'FTCoreUtility/Tests/**/*.swift', 'FTMobileCore/Tests/**/*.swift', 'FTMobileCoreUI/Tests/**/*.swift'
      testing.frameworks = 'XCTest'
  end
  
end
