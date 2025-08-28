// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "OnboardingModule", targets: ["OnboardingModule"]),
        .library(name: "UserModule", targets: ["UserModule"]),
        .library(name: "PaywallModule", targets: ["PaywallModule"]),
        .library(name: "TransactionModule", targets: ["TransactionModule"]),
        .library(name: "SubscriptionModule", targets: ["SubscriptionModule"]),
        .library(name: "SavingsPlanModule", targets: ["SavingsPlanModule"]),
        .library(name: "ContributionModule", targets: ["ContributionModule"]),
        .library(name: "AccountModule", targets: ["AccountModule"]),
        .library(name: "BudgetModule", targets: ["BudgetModule"]),
        .library(name: "CategoryModule", targets: ["CategoryModule"]),
        .library(name: "SubcategoryModule", targets: ["SubcategoryModule"]),
        .library(name: "SavingsAccountModule", targets: ["SavingsAccountModule"]),
        .library(name: "TransferModule", targets: ["TransferModule"]),
        .library(name: "SettingsModule", targets: ["SettingsModule"]),
        .library(name: "CreditCardModule", targets: ["CreditCardModule"])
    ],
    dependencies: [
        .package(path: "../DesignSystemModule"),
        .package(path: "../CoreModule"),
        .package(path: "../Mocks"),
        .package(path: "../Models"),
        .package(path: "../Stores"),
        .package(path: "../Navigation"),
        
        .package(url: "https://github.com/theosementa/StatsKit", exact: "1.0.8"),
        .package(url: "https://github.com/theosementa/AlertKit", branch: "main"),
        .package(url: "https://github.com/theosementa/NavigationKit", branch: "2.0.2"),
        .package(url: "https://github.com/theosementa/NetworkKit", branch: "1.0.3"),
        .package(url: "https://github.com/theosementa/NotificationKit", branch: "1.0.5"),
        .package(url: "https://github.com/theosementa/TheoKit", branch: "1.0.7"),

        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.9.3"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", exact: "9.0.0"),
        .package(url: "https://github.com/simibac/ConfettiSwiftUI", branch: "1.0.0"),
        .package(url: "https://github.com/izyumkin/MCEmojiPicker", branch: "1.2.3"),
        .package(url: "https://github.com/aheze/SwipeActions", branch: "1.1.0")
    ],
    targets: [
        .target(
            name: "OnboardingModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "UserModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "OnboardingModuleTests", dependencies: ["OnboardingModule"]),
        
        .target(
            name: "UserModule",
            dependencies: [
                "CoreModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "NetworkKit", package: "NetworkKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "UserModuleTests", dependencies: ["UserModule"]),
        
        .target(
            name: "PaywallModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "PaywallModuleTests", dependencies: ["PaywallModule"]),
        
        .target(
            name: "TransactionModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "TransactionModuleTests", dependencies: ["TransactionModule"]),
        
        .target(
            name: "SubscriptionModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SubscriptionModuleTests", dependencies: ["SubscriptionModule"]),
        
        .target(
            name: "SavingsPlanModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "ContributionModule",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SavingsPlanModuleTests", dependencies: ["SavingsPlanModule"]),
        
        .target(
            name: "ContributionModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "ContributionModuleTests", dependencies: ["ContributionModule"]),
        
        .target(
            name: "AccountModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "AccountModuleTests", dependencies: ["AccountModule"]),
        
        .target(
            name: "BudgetModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "BudgetModuleTests", dependencies: ["BudgetModule"]),
        
        .target(
            name: "CategoryModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "CategoryModuleTests", dependencies: ["CategoryModule"]),
        
        .target(
            name: "SubcategoryModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SubcategoryModuleTests", dependencies: ["SubcategoryModule"]),
        
        .target(
            name: "SavingsAccountModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "TransferModule",
                "AccountModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "NavigationKit", package: "NavigationKit"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SavingsAccountModuleTests", dependencies: ["SavingsAccountModule"]),
        
        .target(
            name: "TransferModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "TransferModuleTests", dependencies: ["TransferModule"]),
        
        .target(
            name: "SettingsModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "AccountModule",
                "SubscriptionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SettingsModuleTests", dependencies: ["SettingsModule"]),
        
        .target(
            name: "CreditCardModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "CreditCardModuleTests", dependencies: ["CreditCardModule"])
    ]
)
