// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let dependencies: [Target.Dependency] = ["CoreUtility", "CoreComponents"]
private let resources: [Resource] = [ .process("Resources") ]

let package = Package(
    name: "MobileCore",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "CoreUtility", targets: ["CoreUtility"]),
        .library(name: "CoreComponents", targets: ["CoreComponents"]),
        .library(name: "AppTheming", targets: ["AppTheming"]),
        .library(name: "NetworkLayer", targets: ["NetworkLayer"]),
        .library(name: "MobileTheming", targets: ["MobileTheming"])
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "MobileTheme", url: "https://github.com/ppraveentr/MobileTheme.git", from: "1.2.0")
    ],
    targets: [
        // MARK: CoreUtility
        .target(name: "CoreUtility", dependencies: []),
        .testTarget(name: "CoreUtilityTests", dependencies: ["CoreUtility"], resources: resources),
        
        // MARK: CoreComponents
        .target(name: "CoreComponents", dependencies: ["CoreUtility"]),
        .testTarget(name: "CoreComponentsTests", dependencies: dependencies, resources: resources),
        
        // MARK: AppTheming
        .target(name: "AppTheming", dependencies: dependencies),
        .testTarget(name: "AppThemingTests", dependencies: dependencies + ["AppTheming"], resources: resources),
        
        // MARK: NetworkLayer
        .target(name: "NetworkLayer", dependencies: dependencies),
        .testTarget(name: "NetworkLayerTests", dependencies: dependencies + ["NetworkLayer"], resources: resources),
        
        // MARK: SwiftUI Theming
        .target(name: "MobileTheming", dependencies: ["MobileTheme"])
    ],
    swiftLanguageVersions: [.v5]
)
