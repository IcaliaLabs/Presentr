// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Presentr",
	platforms: [.iOS(.v11)],
	products: [
		.library(name: "Presentr", targets: ["Presentr"]),
	],
	targets: [
		.target(name: "Presentr", path: "Presentr")
	]
)
