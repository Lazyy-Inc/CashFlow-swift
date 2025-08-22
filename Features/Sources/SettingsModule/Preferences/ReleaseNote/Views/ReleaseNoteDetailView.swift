//
//  ReleaseNoteDetailView.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import SwiftUI
import DesignSystemModule
import CoreModule

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
                            .fontWithLineHeight(.Title.large)
                        
                        Text(releaseNote.date)
                            .fontWithLineHeight(.Body.medium)
                            .foregroundStyle(Color(UIColor.lightGray))
                    }
                    .fullWidth(.leading)
                    
                    if let newFeatures = releaseNote.newFeatures, newFeatures.isEmpty == false {
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_new_features".localized)
                                .fontWithLineHeight(.Title.medium)
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(newFeatures, id: \.self) { feature in
                                Text("- \(feature)")
                                    .fontWithLineHeight(.Body.medium)
                            }
                        }
                    }
                    
                    if let newFeaturesPro = releaseNote.newFeaturesPro, newFeaturesPro.isEmpty == false {
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_new_features_pro".localized)
                                .fontWithLineHeight(.Title.medium)
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(newFeaturesPro, id: \.self) { feature in
                                Text("- \(feature)")
                                    .fontWithLineHeight(.Body.medium)
                            }
                        }
                    }
                    
                    if let bugfixes = releaseNote.bugfixes, bugfixes.isEmpty == false {
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_bugfixes".localized)
                                .fontWithLineHeight(.Title.medium)
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(bugfixes, id: \.self) { bug in
                                Text("- \(bug)")
                                    .fontWithLineHeight(.Body.medium)
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
