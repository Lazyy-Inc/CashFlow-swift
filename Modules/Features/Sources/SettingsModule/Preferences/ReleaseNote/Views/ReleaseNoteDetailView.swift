//
//  ReleaseNoteDetailView.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import SwiftUI
import DesignSystem
import Core
import Models

public struct ReleaseNoteDetailView: View {
    
    var releaseNote: ReleaseNoteModel
    
    public init(releaseNote: ReleaseNoteModel) {
        self.releaseNote = releaseNote
    }
    
    // MARK: -
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: Spacing.large) {
                    VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                        Text("\("release_note_title".localized) \(releaseNote.version)")
                            .font(.Title.large)
                        
                        Text(releaseNote.date)
                            .font(.Body.medium)
                            .foregroundStyle(Color(UIColor.lightGray))
                    }
                    .fullWidth(.leading)
                    
                    if let newFeatures = releaseNote.newFeatures, newFeatures.isEmpty == false {
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_new_features".localized)
                                .font(.Title.medium)
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(newFeatures, id: \.self) { feature in
                                Text("- \(feature)")
                                    .font(.Body.medium)
                            }
                        }
                    }
                    
                    if let newFeaturesPro = releaseNote.newFeaturesPro, newFeaturesPro.isEmpty == false {
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_new_features_pro".localized)
                                .font(.Title.medium)
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(newFeaturesPro, id: \.self) { feature in
                                Text("- \(feature)")
                                    .font(.Body.medium)
                            }
                        }
                    }
                    
                    if let bugfixes = releaseNote.bugfixes, bugfixes.isEmpty == false {
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_bugfixes".localized)
                                .font(.Title.medium)
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(bugfixes, id: \.self) { bug in
                                Text("- \(bug)")
                                    .font(.Body.medium)
                            }
                        }
                    }
                }
                .padding(Padding.large)
            }
        }
        .toolbar {
            ToolbarDismissPushButton()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    } // body
} // struct

// MARK: - Preview
#Preview {
    ReleaseNoteDetailView(releaseNote: .version2_0_4)
}
