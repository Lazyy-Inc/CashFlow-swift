//
//  TransactionMapRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation
import SwiftUI
import MapKit
import Core
import DesignSystem
import Models

struct TransactionMapRow: View {
    
    // dependencies
    var transaction: TransactionModel
  
  var coordinates: CLLocationCoordinate2D {
    let coordinates = CLLocationCoordinate2D(
      latitude: transaction.lat ?? 0,
      longitude: transaction.long ?? 0
    )
    return coordinates
  }
        
    var cameraPosition: MapCameraPosition {
      return .region(.init(
            center: coordinates,
            latitudinalMeters: 400,
            longitudinalMeters: 400)
        )
    }
    
    // MARK: -
    var body: some View {
        let systemImage: String = transaction.subcategory?.icon ?? "iconQuestionFile"
        Map(initialPosition: cameraPosition) {
            Annotation(transaction.nameDisplayed, coordinate: coordinates) {
                IconSVG(icon: systemImage, value: .standard)
                    .foregroundStyle(Color.white)
                    .padding(6)
                    .background {
                        Circle()
                            .fill(transaction.category?.color ?? .blue)
                    }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .frame(height: 200)
        .clipShape(.rect(cornerRadius: CornerRadius.standard, style: .continuous))
        .disabled(true)
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionMapRow(transaction: .mockClassicTransaction)
        .padding()
}
