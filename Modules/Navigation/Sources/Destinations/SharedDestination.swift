//
//  SharedDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation
import NavigationKit
import Models

public enum SharedDestination: DestinationItem {
    case sfSafari(url: URL)
    case paywall
    case whatsNew
    case qrCodeScanner
    case releaseNoteDetail(releaseNote: ReleaseNoteModel)
    
    case home
}
