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
          Picker(
            "settings_statistics_repartition_rule".localized,
            selection: $statisticsPreferences.repartitionRule
          ) {
            ForEach(RepartitionRule.allCases, id: \.self) { rule in
              Text(rule.rawValue).tag(rule.rawValue)
            }
          }
          
          Button {
            isSalaryAlertPresented = true
          } label: {
            HStack {
              Text("settings_statistics_salary".localized)
                .fullWidth(.leading)
                .foregroundStyle(Color.Text.primary)
              
              Text(statisticsPreferences.salary.toCurrency())
            }
          }
        } footer: {
          Text(String(format: "settings_statistics_salary_desc".localized, statisticsPreferences.repartitionRule))
        }
    }
    .navigationTitle("settings_statistics_title".localized)
    .navigationBarTitleDisplayMode(.inline)
    .alert("settings_statistics_salary".localized, isPresented: $isSalaryAlertPresented) {
      TextField("settings_statistics_field_salary_placeholder".localized, text: $salaryInput)
        .keyboardType(.decimalPad)
      
      Button("word_cancel".localized, role: .cancel) {
        salaryInput = ""
      }
      Button("word_save".localized) {
        statisticsPreferences.salary = salaryInput.toDouble()
      }
    } message: {
      Text("settings_statistics_field_salary_desc".localized)
    }
  }
  
}

// MARK: - Preview
#Preview {
  SettingsStatisticsScreen()
}
