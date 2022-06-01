// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reachability",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Reachability",
            targets: ["Reachability"]),
    ],
    dependencies: [
         .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "Reachability",
            dependencies: ["Alamofire"]),
    ]
)
