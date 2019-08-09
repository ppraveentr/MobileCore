#!/bin/bash
mkdir -p "Frameworks"

xcodebuild -scheme FTCoreUtility -configuration Release clean archive
xcodebuild -scheme FTMobileCore -configuration Release clean archive
xcodebuild -scheme FTMobileCoreUI -configuration Release clean archive
