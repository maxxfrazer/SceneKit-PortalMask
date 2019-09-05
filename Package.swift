// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PortalMask",
  platforms: [.iOS(.v11)],
  products: [.library(name: "PortalMask", targets: ["PortalMask"])],
  targets: [.target(name: "PortalMask")],
  swiftLanguageVersions: [.v5]
)
