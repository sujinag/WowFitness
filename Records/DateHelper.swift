import Foundation
import CoreData

//struct DateHelper {
//
//    static func predicateForDay(_ date: Date) -> NSPredicate {
//        let start = Calendar.current.startOfDay(for: date)
//        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
//        return NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
//    }
//
//    static func predicateForMonth(_ date: Date) -> NSPredicate {
//        let start = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
//        let end = Calendar.current.date(byAdding: .month, value: 1, to: start)!
//        return NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
//    }
//
//    static func predicateForYear(_ date: Date) -> NSPredicate {
//        let start = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: date))!
//        let end = Calendar.current.date(byAdding: .year, value: 1, to: start)!
//        return NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
//    }
//
//    static func predicateForQuarter(_ date: Date) -> NSPredicate {
//        let quarter = (Calendar.current.component(.month, from: date) - 1) / 3
//        let startMonth = quarter * 3 + 1
//
//        var comps = Calendar.current.dateComponents([ .year ], from: date)
//        comps.month = startMonth
//        comps.day = 1
//
//        let start = Calendar.current.date(from: comps)!
//        let end = Calendar.current.date(byAdding: .month, value: 3, to: start)!
//
//        return NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
//    }
//
//    static func chartValues(for list: [NewClient], period: ReportPeriod) -> [Int] {
//        switch period {
//        case .daily:
//            // group by hour
//            return Array(repeating: 0, count: 6)
//
//        case .monthly:
//            // group by days
//            return Array(repeating: 0, count: 30)
//
//        case .yearly:
//            // months
//            return Array(repeating: 0, count: 12)
//
//        case .quarterly:
//            return Array(repeating: 0, count: 3)
//
////        case .all:
////            return [list.count]
//        }
//    }
//}
//
//import Foundation
//
//struct DateHelper {
//    static let calendar = Calendar.current
//
//    static func startOfDay(_ date: Date) -> Date {
//        calendar.startOfDay(for: date)
//    }
//
//    static func endOfDay(_ date: Date) -> Date {
//        let start = startOfDay(date)
//        return calendar.date(byAdding: .day, value: 1, to: start)?.addingTimeInterval(-1) ?? date
//    }
//
//    static func startOfMonth(_ date: Date) -> Date? {
//        let comps = calendar.dateComponents([.year, .month], from: date)
//        return calendar.date(from: comps)
//    }
//
//    static func endOfMonth(_ date: Date) -> Date? {
//        guard let start = startOfMonth(date),
//              let next = calendar.date(byAdding: .month, value: 1, to: start) else { return nil }
//        return next.addingTimeInterval(-1)
//    }
//
//    static func startOfYear(_ date: Date) -> Date? {
//        let comps = calendar.dateComponents([.year], from: date)
//        return calendar.date(from: comps)
//    }
//
//    static func endOfYear(_ date: Date) -> Date? {
//        guard let start = startOfYear(date),
//              let next = calendar.date(byAdding: .year, value: 1, to: start) else { return nil }
//        return next.addingTimeInterval(-1)
//    }
//
//    static func startOfQuarter(containing date: Date) -> Date? {
//        let comps = calendar.dateComponents([.year, .month], from: date)
//        guard let month = comps.month, let year = comps.year else { return nil }
//        // quarter start month: 1,4,7,10
//        let quarterIndex = ((month - 1) / 3)
//        let startMonth = quarterIndex * 3 + 1
//        var dcomps = DateComponents()
//        dcomps.year = year
//        dcomps.month = startMonth
//        dcomps.day = 1
//        return calendar.date(from: dcomps)
//    }
//
//    static func endOfQuarter(containing date: Date) -> Date? {
//        guard let start = startOfQuarter(containing: date),
//              let next = calendar.date(byAdding: .month, value: 3, to: start) else { return nil }
//        return next.addingTimeInterval(-1)
//    }
//
//    static func daysInMonth(containing date: Date) -> [Date] {
//        guard let start = startOfMonth(date),
//              let end = endOfMonth(date) else { return [] }
//        var days: [Date] = []
//        var current = start
//        while current <= end {
//            days.append(current)
//            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
//            current = next
//        }
//        return days
//    }
//}


import Foundation

struct DateHelper {
    static let calendar = Calendar.current

    static func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    static func endOfDay(_ date: Date) -> Date {
        let start = startOfDay(date)
        return calendar.date(byAdding: .day, value: 1, to: start)?.addingTimeInterval(-1) ?? date
    }

    static func startOfMonth(_ date: Date) -> Date? {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps)
    }

    static func endOfMonth(_ date: Date) -> Date? {
        guard let start = startOfMonth(date),
              let next = calendar.date(byAdding: .month, value: 1, to: start) else { return nil }
        return next.addingTimeInterval(-1)
    }

    static func startOfYear(_ date: Date) -> Date? {
        let comps = calendar.dateComponents([.year], from: date)
        return calendar.date(from: comps)
    }

    static func endOfYear(_ date: Date) -> Date? {
        guard let start = startOfYear(date),
              let next = calendar.date(byAdding: .year, value: 1, to: start) else { return nil }
        return next.addingTimeInterval(-1)
    }
    
    static func startOfHalfYearly(containing date: Date) -> Date? {
        let comps = calendar.dateComponents([.year, .month], from: date)
        guard let month = comps.month, let year = comps.year else { return nil }
        // quarter start month: 1,4,7,10
        let quarterIndex = ((month - 1) / 6)
        let startMonth = quarterIndex * 6 + 1
        var dcomps = DateComponents()
        dcomps.year = year
        dcomps.month = startMonth
        dcomps.day = 1
        return calendar.date(from: dcomps)
    }
    
    static func endOfHalfYearly(containing date: Date) -> Date? {
        guard let start = startOfHalfYearly(containing: date),
              let next = calendar.date(byAdding: .month, value: 6, to: start) else { return nil }
        return next.addingTimeInterval(-1)
    }


    static func startOfQuarter(containing date: Date) -> Date? {
        let comps = calendar.dateComponents([.year, .month], from: date)
        guard let month = comps.month, let year = comps.year else { return nil }
        // quarter start month: 1,4,7,10
        let quarterIndex = ((month - 1) / 3)
        let startMonth = quarterIndex * 3 + 1
        var dcomps = DateComponents()
        dcomps.year = year
        dcomps.month = startMonth
        dcomps.day = 1
        return calendar.date(from: dcomps)
    }

    static func endOfQuarter(containing date: Date) -> Date? {
        guard let start = startOfQuarter(containing: date),
              let next = calendar.date(byAdding: .month, value: 3, to: start) else { return nil }
        return next.addingTimeInterval(-1)
    }

    static func daysInMonth(containing date: Date) -> [Date] {
        guard let start = startOfMonth(date),
              let end = endOfMonth(date) else { return [] }
        var days: [Date] = []
        var current = start
        while current <= end {
            days.append(current)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        return days
    }
}
