//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 29/10/2025.
//

import SwiftUI
import Stores
import Dependencies
import DesignSystem
import Models

struct SubscriptionCalendarView: View {
    
    @Dependency(\.subscriptionStore) var subscriptionStore
    
    // MARK: States
    @State private var selectedMonth: Date = .now
    @State private var selectedDate: Date = .now
    
    // Dictionnaire groupant les transactions par date
    let transactions: [Date: [TransactionModel]]
    
    // MARK: - View
    var body: some View {
        VStack(spacing: 16) {
            // Header avec navigation
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text(monthFormatter.string(from: selectedMonth).capitalized)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            
            // Jours de la semaine
            HStack(spacing: 8) {
                ForEach(["LUN", "MAR", "MER", "JEU", "VEN", "SAM", "DIM"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Grille du calendrier
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: 2), count: 7
                ), spacing: 2
            ) {
                ForEach(0..<daysInMonth.count, id: \.self) { index in
                    CalendarDayCell(
                        date: daysInMonth[index],
                        dayNumber: dayNumber(for: daysInMonth[index]),
                        transactions: transactions(for: daysInMonth[index]),
                        isSelected: isSelected(daysInMonth[index])
                    )
                    .onTapGesture {
                        if let date = daysInMonth[index] {
                            selectedDate = date
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
        )
        .padding(Spacing.medium)
        .roundedRectangleBorder(
            Color.Background.bg100,
            radius: CornerRadius.large,
            lineWidth: 1,
            strokeColor: Color.Background.bg200
        )
    }
    
    // MARK: - Actions
    private func previousMonth() {
        selectedMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
    }
    
    private func nextMonth() {
        selectedMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
    }
}

extension SubscriptionCalendarView {
    
    private var calendar: Calendar { Calendar.current }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var days: [Date?] = []
        var currentDate = monthFirstWeek.start
        
        // Générer 6 semaines (42 jours) pour couvrir tous les cas
        for _ in 0..<42 {
            if calendar.isDate(currentDate, equalTo: selectedMonth, toGranularity: .month) {
                days.append(currentDate)
            } else {
                days.append(nil)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
    private func dayNumber(for date: Date?) -> Int? {
        guard let date = date else { return nil }
        return calendar.component(.day, from: date)
    }
    
    private func transactions(for date: Date?) -> [TransactionModel] {
        guard let date = date,
              let normalizedDate = calendar.startOfDay(for: date) as Date?,
              let trans = transactions[normalizedDate] else {
            return []
        }
        return trans
    }
    
    private func isSelected(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date?
    let dayNumber: Int?
    let transactions: [TransactionModel]
    let isSelected: Bool
    
    @Environment(\.theme) private var theme
    
    var transactionCount: Int {
        return transactions.count
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(date == nil ? Color.Background.bg50 : Color.Background.bg200)
            .fullWidth()
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? theme.color : Color.clear, lineWidth: 2)
            )
            .overlay {
                if let dayNumber {
                    VStack {
                        if let firstTransaction = transactions.first {
                            Circle()
                                .fill(firstTransaction.color)
                                .frame(width: 20, height: 20)
                                .overlay {
                                    if let subcategory = firstTransaction.subcategory {
                                        IconSVG(icon: subcategory.icon, value: .small)
                                    } else if let category = firstTransaction.category {
                                        IconSVG(icon: category.icon, value: .small)
                                    }
                                }
                                .overlay {
                                    if transactionCount > 1 {
                                        Text("+\(transactionCount - 1)")
                                            .fontWithLineHeight(.Label.small)
                                            .foregroundColor(Color.Background.bg600)
                                            .frame(width: 22, height: 22)
                                            .roundedRectangleBorder(
                                                Color.Background.bg300,
                                                radius: 100,
                                                lineWidth: 3,
                                                strokeColor: Color.Background.bg200
                                            )
                                            .offset(x: 12)
                                    }
                                }
                                .offset(x: transactionCount > 1 ? -6 : 0)
                        }
                        
                        Text("\(dayNumber)")
                            .fontWithLineHeight(.Label.small)
                            .foregroundColor(Color.Background.bg600)
                    }
                    .padding(.vertical, Spacing.small)
                }
            }
    }
}

// MARK: - Preveiw
#Preview {
    SubscriptionCalendarView(transactions: SubscriptionCalendarView.sampleTransactions())
}

extension SubscriptionCalendarView {
    static func sampleTransactions() -> [Date: [TransactionModel]] {
        let calendar = Calendar.current
        var dict: [Date: [TransactionModel]] = [:]
        
        // Quelques dates avec transactions
        let dates = [8, 13, 22, 26]
        for day in dates {
            if let date = calendar.date(from: DateComponents(year: 2025, month: 10, day: day)) {
                let normalizedDate = calendar.startOfDay(for: date)
                let count = day == 8 || day == 22 ? 3 : 1
                dict[normalizedDate] = (0..<count).map { i in
                    TransactionModel(id: UUID().hashValue, name: "Transaction \(i)", amount: Double(i * 10), date: date)
                }
            }
        }
        
        return dict
    }
}
