// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let testDependencies: [Target.Dependency] = ["CoreUtility", "CoreUI"]
private let coreUtilityResources = "Tests/CoreUtilityTests/Resources"
private let coreUIResources = "Sources/CoreUI/Resources"

let package = Package(
    name: "MobileCore",
    platforms: [.iOS(.v10)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "CoreUtility", targets: ["CoreUtility"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(name: "AppTheming", targets: ["AppTheming"]),
        .library(name: "NetworkLayer", targets: ["NetworkLayer"])
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // MARK: CoreUtility
        .target(name: "CoreUtility", dependencies: []),
        .testTarget(name: "CoreUtilityTests", dependencies: ["CoreUtility"], resources: [ .copy(coreUtilityResources) ]),
        
        // MARK: CoreUI
        .target(name: "CoreUI", dependencies: ["CoreUtility"]),
        .testTarget(name: "CoreUITests", dependencies: testDependencies, resources: [ .copy(coreUIResources) ]),
        
        // MARK: AppTheming
        .target(name: "AppTheming", dependencies: testDependencies),
        .testTarget(name: "AppThemingTests", dependencies: ["AppTheming", "CoreUtility", "CoreUI"]),
        
        // MARK: NetworkLayer
        .target(name: "NetworkLayer", dependencies: testDependencies),
        .testTarget(name: "NetworkLayerTests", dependencies: ["NetworkLayer", "CoreUtility", "CoreUI"]),
    ]
)
