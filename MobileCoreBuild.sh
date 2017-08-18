mkdir -p "Frameworks"

xcodebuild -scheme FTCoreUtility archive
xcodebuild -scheme FTMobileCore archive
xcodebuild -scheme FTMobileCoreUI archive

exit 0