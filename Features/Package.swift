// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "OnboardingModule", targets: ["OnboardingModule"]),
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
        .library(name: "CreditCardModule", targets: ["CreditCardModule"]),
        
        .library(name: "Home", targets: ["Home"]),
        .library(name: "Dashboard", targets: ["Dashboard"]),
        .library(name: "Statistics", targets: ["Statistics"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Core"),
        .package(path: "../Mocks"),
        .package(path: "../Models"),
        .package(path: "../Stores"),
        .package(path: "../Navigation"),
        
        .package(url: "https://github.com/theosementa/AlertKit", branch: "main"),
        .package(url: "https://github.com/theosementa/NavigationKit", branch: "2.0.3"),
        .package(url: "https://github.com/theosementa/NetworkKit", branch: "1.0.4"),
        .package(url: "https://github.com/theosementa/NotificationKit", branch: "1.0.6"),
        .package(url: "https://github.com/theosementa/TheoKit", branch: "1.1.5"),

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
                "DesignSystem",
                "Core",
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
          name: "Home",
          dependencies: [
            "DesignSystem",
            "Core",
            "Mocks",
            "Models",
            "Stores",
            "Navigation",
            "TransactionModule",
            "SavingsPlanModule",
            "SubscriptionModule",
            "CategoryModule"
          ],
          swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "HomeTests", dependencies: ["Home"]),
        
        .target(
          name: "Dashboard",
          dependencies: [
            "DesignSystem",
            "Core",
            "Mocks",
            "Models",
            "Stores",
            "Navigation",
            "CreditCardModule"
          ],
          swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "DashboardTests", dependencies: ["Dashboard"]),
        
        .target(
          name: "Statistics",
          dependencies: [
            "DesignSystem",
            "Core",
            "Mocks",
            "Models",
            "Stores",
            "Navigation"
          ],
          swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "StatisticsTests", dependencies: ["Statistics"]),
        
        .target(
            name: "PaywallModule",
            dependencies: [
                "DesignSystem",
                "Core",
                "Mocks",
                "Models",
                "Stores",
                "Navigation"
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "PaywallModuleTests", dependencies: ["PaywallModule"]),
        
        .target(
            name: "TransactionModule",
            dependencies: [
                "DesignSystem",
                "Core",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwipeActions", package: "SwipeActions")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "TransactionModuleTests", dependencies: ["TransactionModule"]),
        
        .target(
            name: "SubscriptionModule",
            dependencies: [
                "DesignSystem",
                "Core",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwipeActions", package: "SwipeActions")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SubscriptionModuleTests", dependencies: ["SubscriptionModule"]),
        
        .target(
            name: "SavingsPlanModule",
            dependencies: [
                "DesignSystem",
                "Core",
                "ContributionModule",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "MCEmojiPicker", package: "MCEmojiPicker")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SavingsPlanModuleTests", dependencies: ["SavingsPlanModule"]),
        
        .target(
            name: "ContributionModule",
            dependencies: [
                "DesignSystem",
                "Core",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwipeActions", package: "SwipeActions")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "ContributionModuleTests", dependencies: ["ContributionModule"]),
        
        .target(
            name: "AccountModule",
            dependencies: [
                "DesignSystem",
                "Core",
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
                "DesignSystem",
                "Core",
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
                "DesignSystem",
                "Core",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwipeActions", package: "SwipeActions")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "CategoryModuleTests", dependencies: ["CategoryModule"]),
        
        .target(
            name: "SubcategoryModule",
            dependencies: [
                "DesignSystem",
                "Core",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwipeActions", package: "SwipeActions")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SubcategoryModuleTests", dependencies: ["SubcategoryModule"]),
        
        .target(
            name: "SavingsAccountModule",
            dependencies: [
                "DesignSystem",
                "Core",
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
                "DesignSystem",
                "Core",
                "TransactionModule",
                "Mocks",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwipeActions", package: "SwipeActions")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "TransferModuleTests", dependencies: ["TransferModule"]),
        
        .target(
            name: "SettingsModule",
            dependencies: [
                "DesignSystem",
                "Core",
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
                "DesignSystem",
                "Core",
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
