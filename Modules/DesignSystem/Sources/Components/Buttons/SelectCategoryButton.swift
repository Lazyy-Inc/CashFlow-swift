//
//  SelectCategoryButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import Navigation
import Core
import Models

public struct SelectCategoryButton: View {
    
    // Builder
    @Binding var selectedCategory: CategoryModel?
    @Binding var selectedSubcategory: SubcategoryModel?
    
    public init(
        selectedCategory: Binding<CategoryModel?>,
        selectedSubcategory: Binding<SubcategoryModel?>
    ) {
        self._selectedCategory = selectedCategory
        self._selectedSubcategory = selectedSubcategory
    }
        
    // MARK: -
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Word.Classic.category.capitalized)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            NavigationButtonView(
                route: .sheet(style: .large),
                destination: AppDestination.category(
                    .select(
                        selectedCategory: $selectedCategory,
                        selectedSubcategory: $selectedSubcategory
                    )
                )
            ) {
                HStack(spacing: 8) {
                    if let selectedSubcategory, selectedCategory != nil {
                        IconSVG(icon: selectedSubcategory.icon, value: .medium)
                        Text(selectedSubcategory.name)
                    } else if let selectedCategory, selectedSubcategory == nil {
                        IconSVG(icon: selectedCategory.icon, value: .medium)
                        Text(selectedCategory.name)
                    } else {
                        Image("iconFolderPlus")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                        Text(Word.Create.addCategory)
                    }
                }
                .font(.Body.medium, color: selectedCategory == nil ? Color.Text.primary : Color.Base.white)
                .padding(Padding.regular)
                .fullWidth(.leading)
                .roundedBackground(
                    .custom(
                        color: selectedCategory?.color ?? .Background.bg100,
                        radius: .medium,
                        lineWidth: selectedCategory == nil ? 1 : 0,
                        strokeColor: .Background.bg200
                    )
                )
            }
        }
        .fullWidth(.leading)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    SelectCategoryButton(
        selectedCategory: .constant(nil),
        selectedSubcategory: .constant(nil)
    )
    .padding()
    .background(Color.Background.bg50)
}
