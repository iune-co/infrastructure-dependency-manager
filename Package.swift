// swift-tools-version: 5.9

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
    ],
    dependencies: [
        .package(
            url: "https://github.com/iune-co/infrastructure-dependency-container.git",
            exact: Version("1.0.0")
        )
    ],
    targets: [
        .target(
            name: "InfrastructureDependencyManager",
            dependencies: [
                .product(
                    name: "InfrastructureDependencyContainer",
                    package: "infrastructure-dependency-container"
                )
            ]
        ),
        .testTarget(
            name: "InfrastructureDependencyManagerTests",
            dependencies: [
                "InfrastructureDependencyManager"
            ]
        ),
    ]
)