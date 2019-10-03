# MobileCore

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/MobileCore.svg?branch=master)](https://travis-ci.org/ppraveentr/MobileCore)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ppraveentr_MobileCore&metric=alert_status)](https://sonarcloud.io/dashboard?id=ppraveentr_MobileCore)
[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=ppraveentr_MobileCore&metric=ncloc)](https://sonarcloud.io/dashboard?id=ppraveentr_MobileCore)
[![codecov](https://codecov.io/gh/ppraveentr/MobileCore/branch/master/graph/badge.svg)](https://codecov.io/gh/ppraveentr/MobileCore)

Lets consider you are developing a Mobile application, be it for Prototyping or Enterprise, finding right set of utitlies all in one place or configuring application Theme, writing a Network-layer  isn't always easy and its time consuming to write the code from scratch. 

MobileCore takes care of all these hassles for you. Its a Swift library consisting in a set of extensions to help dealing with 
- [x] Programatically groping set of UIElements using auto-layout. 
- [x] Configuring and maintaining Application's theme via simple JSON. 
- [x] Creating and managing RESTfull service layer and Domain Object via JSON.
- [x] Customized UIKit elements.

## Get Started

- Download the source ['MobileCore'](https://github.com/ppraveentr/MobileCore.git) to your subdirectory.
- Add below Projects to yours workspace.
```
MobileCore/
├── FTCoreUtility
├── FTMobileCore
└── FTMobileCoreUI
```
- Folow the steps provided in ['Embedding Frameworks In An App'](https://developer.apple.com/library/content/technotes/tn2435/_index.html) to link the 'MobileCore' frameworks to your Xcode project.
- Add the following imports to your bridging header.
	- #import <FTMobileCore/FTMobileCore.h>
	- #import <FTMobileCoreUI/FTMobileCoreUI.h>

That's it - now your are good to go and start writing beautiful applicaiton! Let the MobileCode most of the heavy lifting for you.

You can find useful information about the components in the [wiki](https://github.com/ppraveentr/MobileCore/wiki).

## TODO List

Below are the list of things I’m in plan adding into Mobile Core.

- Deeplinking and flow controler with content passing.
- Content Management for multi-language support using Core-data.
- Secure storage with Keychain.
- Inbuild Crash reporter.
- Customizing Push notification.
- Simplyfing FTCoreUtility’s FTUI<elements> to swift extension.
- and more!!! as I think through 🤔

## Prototype
[`NovelReader`](https://github.com/ppraveentr/NovelReader) is a prototype describing working of MobileCore.

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/NovelReader.svg?branch=master)](https://travis-ci.org/ppraveentr/NovelReader)


## Credits

Owned and maintained by Praveen P (@ppraveentr).

## Contributing

Bug reports and pull requests are most welcome.

## License

MobileCore is released under the MIT license. See LICENSE for details.

#### Note: The architecture is still under evolution.
