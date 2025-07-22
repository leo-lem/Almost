// swift-tools-version: 6.0

import PackageDescription

let tca = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let deps = Target.Dependency.product(name: "Dependencies", package: "swift-dependencies")
let str = Target.Dependency.product(name: "XCStringsToolPlugin", package: "xcstrings-tool-plugin")
let ext = Target.Dependency.product(name: "SwiftUIExtensions", package: "extensions")

let lint = Target.PluginUsage.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")

let libs: [Target] = [
  .target(name: "App", dependencies: [
    "Auth",
    "NewInsight"
  ], plugins: [lint]),
  
  .target(name: "Auth", dependencies: [
    deps,
    .product(name: "SwiftUIExtensions", package: "extensions"),
    .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
  ], plugins: [lint]),
  
  .target(name: "Data", dependencies: [
    deps,
    .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
    .product(name: "SwiftUIExtensions", package: "extensions")
  ], plugins: [lint]),
  
  .target(name: "NewInsight", dependencies: [
    "Data",
    .product(name: "SwiftUIExtensions", package: "extensions")
  ], plugins: [lint])
]

let package = Package(
  name: "Features",
  defaultLocalization: "en",
  platforms: [.iOS(.v18), .macOS(.v15)],
  products: libs.map { .library(name: $0.name, targets: [$0.name]) },
  dependencies: [
//    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.0.0"),
//    .package(url: "https://github.com/liamnichols/xcstrings-tool-plugin.git", from: "0.1.0"),
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.0.0"),
    .package(path: "../extensions")
  ],
  targets: libs + [
    .testTarget(
      name: "FeaturesTest",
      dependencies: libs.map { .byName(name: $0.name) },
      path: "Test",
      plugins: [lint])
  ]
)
