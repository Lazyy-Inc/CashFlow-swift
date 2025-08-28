//
//  StatisticsModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/12/2024.
//

import Foundation

public struct StatisticsModel: Codable {
    public let week: WeeklyStatistics?
    public let month: MonthlyStatistics?
    public let year: YearlyStatistics?
    
    public init(week: WeeklyStatistics? = nil, month: MonthlyStatistics? = nil, year: YearlyStatistics? = nil) {
        self.week = week
        self.month = month
        self.year = year
    }
}

// MARK: - Weekly
public struct WeeklyStatistics: Codable {
    public let expense: ExpenseWeeklyStatistics?
    public let income: IncomeWeeklyStatistics?
    
    public init(expense: ExpenseWeeklyStatistics?, income: IncomeWeeklyStatistics?) {
        self.expense = expense
        self.income = income
    }
}

public struct ExpenseWeeklyStatistics: Codable {
    public let thisWeek: Double?
    public let lastWeek: Double?
    
    public init(thisWeek: Double?, lastWeek: Double?) {
        self.thisWeek = thisWeek
        self.lastWeek = lastWeek
    }
}

public struct IncomeWeeklyStatistics: Codable {
    public let thisWeek: Double?
    public let lastWeek: Double?
    
    public init(thisWeek: Double?, lastWeek: Double?) {
        self.thisWeek = thisWeek
        self.lastWeek = lastWeek
    }
}

// MARK: - Monthly
public struct MonthlyStatistics: Codable {
    public let expense: ExpenseMonthlyStatistics?
    public let income: IncomeMonthlyStatistics?
    
    public init(expense: ExpenseMonthlyStatistics?, income: IncomeMonthlyStatistics?) {
        self.expense = expense
        self.income = income
    }
}

public struct ExpenseMonthlyStatistics: Codable {
    public let thisMonth: Double?
    public let lastMonth: Double?
    
    public init(thisMonth: Double?, lastMonth: Double?) {
        self.thisMonth = thisMonth
        self.lastMonth = lastMonth
    }
}

public struct IncomeMonthlyStatistics: Codable {
    public let thisMonth: Double?
    public let lastMonth: Double?
    
    public init(thisMonth: Double?, lastMonth: Double?) {
        self.thisMonth = thisMonth
        self.lastMonth = lastMonth
    }
}

// MARK: - Yearly
public struct YearlyStatistics: Codable {
    public let expense: ExpenseYearlyStatistics?
    public let income: IncomeYearlyStatistics?
    
    public init(expense: ExpenseYearlyStatistics?, income: IncomeYearlyStatistics?) {
        self.expense = expense
        self.income = income
    }
}

public struct ExpenseYearlyStatistics: Codable {
    public let thisYear: Double?
    public let lastYear: Double?
    
    public init(thisYear: Double?, lastYear: Double?) {
        self.thisYear = thisYear
        self.lastYear = lastYear
    }
}

public struct IncomeYearlyStatistics: Codable {
    public let thisYear: Double?
    public let lastYear: Double?
    
    public init(thisYear: Double?, lastYear: Double?) {
        self.thisYear = thisYear
        self.lastYear = lastYear
    }
}
