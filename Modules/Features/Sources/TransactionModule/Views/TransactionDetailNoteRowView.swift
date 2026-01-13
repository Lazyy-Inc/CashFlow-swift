//
//  TransactionDetailNoteRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI
import Core
import DesignSystem

public struct TransactionDetailNoteRowView: View {
    
    // Builder
    @Binding var note: String
        
    // Enum
    enum Field: CaseIterable {
        case note
    }
    @FocusState var focusedField: Field?
    
    public init(note: Binding<String>) {
        self._note = note
    }
    
    // MARK: -
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(Word.Classic.note)
                    .font(.Body.medium)
                
                Spacer()
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $note)
                    .focused($focusedField, equals: .note)
                    .scrollContentBackground(.hidden)
                    .font(.Body.medium)
                
                if note.isEmpty {
                    HStack {
                        Text("transaction_detail_note".localized)
                            .font(.Body.medium, color: .Text.secondary)
                        
                        Spacer()
                    }
                    .padding([.leading, .top], 8)
                    .onTapGesture { focusedField = .note }
                }
            }
        }
        .frame(minHeight: 120)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Background.bg100)
        }
    } // body
} // struct

// MARK: - 
#Preview {
    TransactionDetailNoteRowView(note: .constant(""))
        .padding()
        .background(Color.Background.bg50)
}
