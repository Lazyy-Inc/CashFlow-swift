//
//  NavigationButtonView.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/08/2025.
//

import SwiftUI
import NavigationKit

struct NavigationButtonView<Label: View>: View {

    // MARK: Dependencies
    let route: Route
    let destination: AppDestination
    let onDismiss: (() -> Void)?
    let onNavigate: (() -> Void)?
    let label: () -> Label

    // MARK: Init
    init(
        route: Route,
        destination: AppDestination,
        onDismiss: (() -> Void)? = nil,
        onNavigate: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.route = route
        self.destination = destination
        self.onDismiss = onDismiss
        self.onNavigate = onNavigate
        self.label = label
    }

    // MARK: -
    var body: some View {
        GenericNavigationButton(
            route: route,
            destination: destination,
            onDismiss: onDismiss,
            onNavigate: onNavigate,
            label: { label() }
        )
    }
}
