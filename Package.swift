// swift-tools-version: 5.8.1

import PackageDescription

let package = Package(
    name: "InfrastructureDependencyManager",
    products: [
        .library(
            name: "InfrastructureDependencyManager",
            targets: [
                "InfrastructureDependencyManager"
            ]
        ),
        .library(
            name: "InfrastructureDependencyContainer",
            targets: [
                "InfrastructureDependencyContainer"
            ]
        ),
    ],
    targets: [
        .target(
            name: "InfrastructureDependencyManager",
            dependencies: [
				"InfrastructureDependencyContainer"
            ]
        ),
		.target(
            name: "InfrastructureDependencyContainer",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "InfrastructureDependencyManagerTests",
            dependencies: [
                "InfrastructureDependencyManager"
            ]
        )
    ]
)
