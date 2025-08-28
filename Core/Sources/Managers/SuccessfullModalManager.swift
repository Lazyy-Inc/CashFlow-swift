//
//  SuccessfullModalManager.swift
//  Core
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import SwiftUI

public final class SuccessfullModalManager: ObservableObject {
    public static let shared = SuccessfullModalManager()
    
    @Published public var isPresenting: Bool = false
    
    @Published public var title: String = ""
    @Published public var subtitle: String = ""
    @Published public var content: any View = EmptyView()
    
}

public extension SuccessfullModalManager {
    
    func resetData() {
        self.title = ""
        self.subtitle = ""
        self.content = EmptyView()
    }
    
}
