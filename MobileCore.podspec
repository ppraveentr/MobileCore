Pod::Spec.new do |s|
  s.name             = 'MobileCore'
  s.version          = '0.1.1'
  s.summary          = 'MobileCore framework.'
  s.homepage         = 'https://github.com/ppraveentr/MobileCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PraveenP' => 'ppraveentr@gmail.com' }
  s.source           = { :git => 'https://github.com/ppraveentr/MobileCore.git', :tag => s.version.to_s }
  s.weak_framework 	 = 'UIKit'

  s.ios.deployment_target = '9.0'
  s.swift_version         = '5.0'
  s.default_subspecs      = 'CoreUtility', 'NetworkLayer', 'CoreUI', 'AppTheming'

  s.subspec 'CoreUtility' do |utility|
    utility.source_files  = 'CoreUtility/Classes/**/*.{h,m,swift}'
    utility.header_dir    = "CoreUtility"
    utility.dependency  'SwiftKeychainWrapper'
  end

  s.subspec 'NetworkLayer' do |network|
    network.source_files   = 'NetworkLayer/Classes/**/*.{h,m,swift}'
    network.dependency  'MobileCore/CoreUtility'
    network.header_dir    = "NetworkLayer"
  end
  
  s.subspec 'AppTheming' do |theme|
    theme.source_files   = 'AppTheming/Classes/**/*.{h,m,swift}'
    theme.dependency  'MobileCore/CoreUtility'
    theme.header_dir    = "AppTheming"
  end

  s.subspec 'CoreUI' do |coreUI|
    coreUI.source_files = 'CoreUI/Classes/**/*.{h,m,swift}'
    coreUI.resources    = ['CoreUI/Assets/**/*', 'CoreUI/Classes/**/*.xib']
    coreUI.dependency  'MobileCore/CoreUtility'
    coreUI.header_dir   = "CoreUI"
  end
  
end
