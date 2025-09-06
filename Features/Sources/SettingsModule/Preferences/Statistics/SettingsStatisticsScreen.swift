//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 05/09/2025.
//

import SwiftUI
import Preferences
import Models

public struct SettingsStatisticsScreen: View {
  
  public init() { }
  
  @StateObject private var statisticsPreferences: StatisticsPreferences = .shared
  @State private var isSalaryAlertPresented: Bool = false
  @State private var salaryInput: String = ""
  
  // MARK: -
  public var body: some View {
    Form {
        Section {
          Picker("Règle de répartition", selection: $statisticsPreferences.repartitionRule) { // TODO: TBL
            ForEach(RepartitionRule.allCases, id: \.self) { rule in
              Text(rule.rawValue).tag(rule.rawValue)
            }
          }
          
          Button {
            isSalaryAlertPresented = true
          } label: {
            HStack {
              Text("Salaire pour appliquer la règle \(statisticsPreferences.repartitionRule)") // TODO: TBL
                .fullWidth(.leading)
              
              Text(statisticsPreferences.salary.toCurrency())
            }
          }
        } footer: {
          
        }
    }
    .navigationTitle("word_account".localized)
    .navigationBarTitleDisplayMode(.inline)
    .alert("Enter your name", isPresented: $isSalaryAlertPresented) { // TODO: TBL
      TextField("Enter your salary", text: $salaryInput) // TODO: TBL
        .keyboardType(.decimalPad)
      
      Button("Annuler".localized, role: .cancel) { // TODO: TBL
        salaryInput = ""
      }
      Button("Enregistrer".localized) { // TODO: TBL
        statisticsPreferences.salary = salaryInput.toDouble()
      }
    } message: {
      Text("Votre salaire serviera uniquement pour appliquer la règle de répartition choisie.") // TODO: TBL
    }
  }
  
}

// MARK: - Preview
#Preview {
  SettingsStatisticsScreen()
}
