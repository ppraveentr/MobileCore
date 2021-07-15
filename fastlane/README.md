fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### lint
```
fastlane lint
```
Does a static analysis of the project. Configure the options in .swiftlint.yml
### test
```
fastlane test
```
Runs all the unit tests and UI Tests
### podlibLint
```
fastlane podlibLint
```
Cocoapods Spec Lint
### create_release
```
fastlane create_release
```
Create Release Branch

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
