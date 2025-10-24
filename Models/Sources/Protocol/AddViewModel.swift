//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 24/10/2025.
//

import Foundation
import SwiftUI

public protocol AddViewModel {
    var navigationTitle: String { get }
    var actionButtonTitle: String { get }
    var isAlertLeavePresented: Bool { get set }
    
    var isModelInCreation: Bool { get }
    var isModelValid: Bool { get }
    
    func validationAction(dismiss: DismissAction) async
    func dismissAction(dismiss: DismissAction)
}
