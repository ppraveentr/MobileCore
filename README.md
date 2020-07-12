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
- [x] Customized UIKit elements extensions for ease of use.

### Using CococaPods

Before we create our new iOS project, 
lets discuss the libraries and resources we will use.

We'll be using CocoaPods to manage our dependencies. 
CocoaPods is a Ruby gem and command line tool  that makes it easy to add dependencies to your project. 
We prefer CocoaPods over Git submodules  due to its ease of implementation  and the wide variety of third-party libraries available as pods. 
CocoaPods will not only download the libraries we need and link them to our project in Xcode, it will also allow us to easily manage  and update which version of each library we want to use.

### CocoaPods Setup

What follows is a succinct version of the instructions on the [CocoaPods](http://guides.cocoapods.org/using/getting-started.html) website:

1. `$ gem install cocoapods` or `$ gem install cocoapods --pre` to use the latest version. The Podfile we provide in the next section uses CocoaPods v1.0 syntax.

2. Navigate to your iOS project's root directory.

3. Create a text file named `Podfile` using your editor of choice.

4. `$ pod install`

5. If you have your iOS project open in Xcode, close it and reopen the workspace that CocoaPods generated for you.

6. When using CocoaPods in conjunction with Git, you may choose to ignore the Pods directory so the libraries that CocoaPods downloads are not under version control. If you want to do this, add `Pods` your .gitignore. Anyone who clones your project will need to `$ pod install` to retrieve the libraries that the project requires.

### MobileCore's Podfile

Installing the CocoaPods gem and creating a podfile is covered in more detail on their website. 
Below is the podfile we're going to use for this project.

	platform :ios, '9.0'

	target 'YourMobileApp' do
		pod 'MobileCore', '~> 0.1.0'
	end

Once you've updated your podfile, go ahead and run `$ pod install`
That's it - now your are good to go and start writing beautiful applicaiton! Let the MobileCode most of the heavy lifting for you.

You can find useful information about the components in the [wiki](https://github.com/ppraveentr/MobileCore/wiki).

## TODO List

Below are the list of things I’m in plan adding into Mobile Core.

- Deeplinking and flow controler with content passing.
- Content Management for multi-language support using Core-data.
- Inbuild Crash reporter.
- Customizing Push notification.
- and more!!! as I think through 🤔

## Credits

Owned and maintained by Praveen P (@ppraveentr).

## Contributing

Bug reports and pull requests are most welcome.

## License

MobileCore is released under the MIT license. See LICENSE for details.

#### Note: The architecture is still under evolution.
