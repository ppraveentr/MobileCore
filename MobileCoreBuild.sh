#!/bin/bash
mkdir -p "buildFramework"

cd FTCoreUtility
xcodebuild -scheme FTCoreUtility -configuration Release clean archive
cd ..
cd FTMobileCore
xcodebuild -scheme FTMobileCore -configuration Release clean archive
cd ..
cd FTMobileCoreUI
xcodebuild -scheme FTMobileCoreUI -configuration Release clean archive
cd ..
