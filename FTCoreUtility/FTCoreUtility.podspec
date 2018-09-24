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
  s.author             = { "PraveenP" => "ppraveentr@gmail.com" }
  
  s.platform     = :ios, "9.0"

  s.source       = { :http => 'https://github.com/ppraveentr/MobileCore/tree/master/FTCoreUtility' }

  s.source_files  = "FTCoreUtility", "FTCoreUtility/**/*.{h,m,swift}"

  #s.exclude_files = "Classes/Exclude"
  #s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }

  s.frameworks = "Foundation", "UIKit"
  
end
