//
//  TransactionMapRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation
import SwiftUI
import MapKit
import CoreModule
import DesignSystemModule
import Models
import Mocks

@available(iOS 17.0, *)
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
                    .padding(6)
                    .background {
                        Circle()
                            .fill(transaction.category?.color ?? .blue)
                    }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    } // body
} // struct

// MARK: - Preview
#Preview {
    if #available(iOS 17.0, *) {
        TransactionMapRow(transaction: .mockClassicTransaction)
            .padding()
    } else {
        // Fallback on earlier versions
    }
}
