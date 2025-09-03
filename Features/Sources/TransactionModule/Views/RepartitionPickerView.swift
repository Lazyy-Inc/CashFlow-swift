////
////  RepartitionPickerView.swift
////  Features
////
////  Created by Theo Sementa on 02/09/2025.
////
//
//import SwiftUI
//import TheoKit
//import Core
//import DesignSystem
//import Models
//
//struct RepartitionPickerView: View {
//    
//    @Binding var selected: RepartitionPickerView
//        
//    @EnvironmentObject private var themeManager: ThemeManager
//    
//    // MARK: -
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            Text(Word.Classic.frequency)
//                .padding(.leading, 8)
//                .font(.system(size: 12, weight: .regular))
//            
//            HStack(spacing: 0) {
//                Spacer()
//                Picker(selection: $selected) {
//                    ForEach(SubscriptionFrequency.allCases, id: \.self) { type in
//                        Text(type.name).tag(type)
//                    }
//                } label: {
//                    Text(selected.name)
//                }
//                .tint(themeManager.theme.color)
//                .padding(8)
//            }
//            .roundedRectangleBorder(
//                TKDesignSystem.Colors.Background.Theme.bg100,
//                radius: CornerRadius.medium,
//                lineWidth: 1,
//                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
//            )
//        }
//    } // body
//} // struct
//
//// MARK: - Preview
//#Preview {
//  RepartitionPickerView(selected: .constant(.monthly))
//}
