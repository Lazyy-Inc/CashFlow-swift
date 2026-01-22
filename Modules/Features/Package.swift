// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "OnboardingModule", targets: ["OnboardingModule"]),
        .library(name: "TransactionModule", targets: ["TransactionModule"]),
        .library(name: "SubscriptionModule", targets: ["SubscriptionModule"]),
        .library(name: "FinancialGoalModule", targets: ["FinancialGoalModule"]),
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
        .library(name: "Savings", targets: ["Savings"]),
        .library(name: "Statistics", targets: ["Statistics"]),
        
        // New clean packages
        .library(name: "Paywall", targets: ["Paywall"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Core"),
        .package(path: "../Models"),
        .package(path: "../Stores"),
        .package(path: "../Navigation"),
        .package(path: "../Utilities"),
        .package(path: "../DataSources"),
        
        .package(url: "https://github.com/theosementa/AlertKit", branch: "main"),
        .package(url: "https://github.com/theosementa/NetworkKit", branch: "1.0.4"),
        .package(url: "https://github.com/theosementa/NotificationKit", branch: "1.0.6"),
        .package(url: "https://github.com/theosementa/TheoKit", branch: "1.1.5"),

        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.9.3"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", exact: "9.0.0"),
        .package(url: "https://github.com/simibac/ConfettiSwiftUI", branch: "1.0.0"),
        .package(url: "https://github.com/izyumkin/MCEmojiPicker", branch: "1.2.3")
    ],
    targets: [
        .target(
            name: "Paywall",
            dependencies: [
                "DesignSystem",
                "Core",
                "Models",
                "Stores",
                "Navigation"
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "OnboardingModule",
            dependencies: [
                "DesignSystem",
                "Core",
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
                "Models",
                "Stores",
                "Navigation",
                .product(name: "DataSources", package: "DataSources"),
                "TransactionModule",
                "FinancialGoalModule",
                "SubscriptionModule",
                "CategoryModule"
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "HomeTests", dependencies: ["Home"]),
        .target(
            name: "Savings",
            dependencies: [
                "DesignSystem",
                "Core",
                "Models",
                "Stores",
                "Navigation",
                "FinancialGoalModule",
                "SavingsAccountModule"
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SavingsTests", dependencies: ["Savings"]),
        .target(
            name: "Statistics",
            dependencies: [
                "DesignSystem",
                "Core",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "DataSources", package: "DataSources")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "StatisticsTests", dependencies: ["Statistics"]),
        .target(
            name: "TransactionModule",
            dependencies: [
                "DesignSystem",
                "Core",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "DataSources", package: "DataSources"),
                .product(name: "Dependencies", package: "swift-dependencies")
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
                "Models",
                "Stores",
                "Navigation",
                .product(name: "DataSources", package: "DataSources"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "SubscriptionModuleTests", dependencies: ["SubscriptionModule"]),
        .target(
            name: "FinancialGoalModule",
            dependencies: [
                "DesignSystem",
                "Core",
                "ContributionModule",
                "TransactionModule",
                "Models",
                "Stores",
                "Navigation",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "MCEmojiPicker", package: "MCEmojiPicker")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(name: "FinancialGoalModuleTests", dependencies: ["FinancialGoalModule"]),
        .target(
            name: "ContributionModule",
            dependencies: [
                "DesignSystem",
                "Core",
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
                "DesignSystem",
                "Core",
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
                "Models",
                "Stores",
                "Navigation",
                .product(name: "DataSources", package: "DataSources"),
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
                "Models",
                "Stores",
                "Navigation",
                "Utilities",
                .product(name: "DataSources", package: "DataSources"),
                .product(name: "Dependencies", package: "swift-dependencies")
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
                "Models",
                "Stores",
                "Navigation",
                .product(name: "DataSources", package: "DataSources"),
                .product(name: "Dependencies", package: "swift-dependencies")
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
                "Models",
                "Stores",
                "Navigation",
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
                "DesignSystem",
                "Core",
                "AccountModule",
                "SubscriptionModule",
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
