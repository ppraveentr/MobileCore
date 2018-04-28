# MobileCore

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/MobileCore.svg?branch=master)](https://travis-ci.org/ppraveentr/MobileCore)

Lets consider you are developing a Mobile application, be it for Prototyping or Enterprise, writing Auto-Layout or Network-layer code from scratch isn't always easy and its time consuming. This Core component takes care of all these hassles for you.


## Prototype: [`NovelReader`](https://github.com/ppraveentr/Concepts/tree/master/NovelReader)
[`NovelReader`](https://github.com/ppraveentr/Concepts/tree/master/NovelReader) is a prototype describing working of MobileCore.

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)
[![Build Status](https://travis-ci.org/ppraveentr/Concepts.svg?branch=master)](https://travis-ci.org/ppraveentr/Concepts)

MobileCore is a Swift library consisting in a set of extensions to help dealing with 
- [x] Auto Layout programatically. 
- [x] Defining and managing RESTfull service layer in JSON format.
- [x] Utility for Domain Object creation from JSON to Swift classes.


## Manually from GitHub

- Download the source files in the MobileCore subdirectory.
- Add the source files to your Xcode project.
- Add the following imports to your bridging header.
	- #import <FTMobileCore/FTMobileCore.h>
	- #import <FTMobileCoreUI/FTMobileCoreUI.h>

That's it - now go write some beautiful Auto Layout code!

### What's included

Within the download you'll find the following sub-projects and an integrated sample workspace `FTMobileCoreSampleWorkspace`.

```
MobileCore/
├── FTMobileCore
├── FTMobileCoreUI
├── FTCoreUtility
└── FTMobileCoreSampleWorkspace
```

## Credits

Owned and maintained by Praveen P (@ppraveentr).

## Contributing

Bug reports and pull requests are welcome.

## License

MobileCore is released under the MIT license. See LICENSE for details.

#### Note
MobileCore architecture is still under evolution.
