import Foundation
import CoreData

class ReportsViewModel: ObservableObject {
    @Published var transactions: [NewClient] = []
    @Published var chartValues: [Int] = []
    @Published var totalAmount: Int = 0
    
    private let context = DatabasePersistent.shared.context


    // MARK: - Load data
//    func loadData(period: ReportPeriod, date: Date) {
//        switch period {
//        case .daily:
//            fetchDaily(date)
//        case .monthly:
//            fetchMonthly(date)
//        case .quarterly:
//            fetchQuarterly(date)
//        case .yearly:
//            fetchYearly(date)
//        }
//    }
//
//}

//extension ReportsViewModel {
//
//    // DAILY
//    func fetchDaily(_ date: Date) {
//        let start = date.startOfDay()
//        let end = date.endOfDay()
//        load(from: start, to: end)
//    }
//
//    // MONTHLY
//    func fetchMonthly(_ date: Date) {
//        load(from: date.startOfMonth(), to: date.endOfMonth())
//    }
//
//    // QUARTERLY
//    func fetchQuarterly(_ date: Date) {
//        load(from: date.startOfQuarter(), to: date.endOfQuarter())
//    }
//
//    // YEARLY
//    func fetchYearly(_ date: Date) {
//        load(from: date.startOfYear(), to: date.endOfYear())
//    }
//
//    // MAIN FETCH
//    private func load(from: Date, to: Date) {
//        let request = NSFetchRequest<NewClient>(entityName: "NewClient")
//        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", from as CVarArg, to as CVarArg)
//
//        do {
//            transactions = try context.fetch(request)
//
//            totalAmount = transactions.reduce(0) { $0 + Int($1.price) }
//            chartValues = buildChartValues()
//
//        } catch {
//            print("Fetch error:", error)
//        }
//    }
//
//    // Simple chart values based on price
//    private func buildChartValues() -> [Int] {
//        transactions.map { Int($0.price) }
//    }
}
