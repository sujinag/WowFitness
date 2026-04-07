import SwiftUI

enum ReportPeriod: String, CaseIterable {
    case daily = "Day"
    case monthly = "Month"
    case quarterly = "Quarter"
    case half = "Half"
    case yearly = "Year"
    case all = "All"
}

struct ReportsView: View {
    @StateObject var vm = DatabaseCombine()
    @State private var period: ReportPeriod = .daily
    @State private var selectedDate: Date = Date()
    // computed totals based on vm.clientDetails For summary
    private func totalForToday() -> Double {
        let start = DateHelper.startOfDay(selectedDate)
        let end = DateHelper.endOfDay(selectedDate)
        let sum = vm.clientDetails.reduce(0.0) { acc, item in
            if let d = item.date, d >= start && d <= end {
                return acc + Double(item.price)
            } else { return acc }
        }
        return sum
    }

    private func totalForMonth() -> Double {
        guard let start = DateHelper.startOfMonth(selectedDate),
              let end = DateHelper.endOfMonth(selectedDate) else { return 0 }
        let sum = vm.clientDetails.reduce(0.0) { acc, item in
            if let d = item.date, d >= start && d <= end {
                return acc + Double(item.price)
            } else { return acc }
        }
        return sum
    }

    private func totalForYear() -> Double {
        guard let start = DateHelper.startOfYear(selectedDate),
              let end = DateHelper.endOfYear(selectedDate) else { return 0 }
        let sum = vm.clientDetails.reduce(0.0) { acc, item in
            if let d = item.date, d >= start && d <= end {
                return acc + Double(item.price)
            } else { return acc }
        }
        return sum
    }

    // Chart data generator:
    private func chartData(for period: ReportPeriod) -> [BarChartDataPoint] {
        switch period {
        case .daily:
            // Show last 7 days totals (or current month days if you prefer)
            let days = (0..<7).map { DateHelper.calendar.date(byAdding: .day, value: -($0), to: selectedDate)! }.reversed()
            return days.map { day in
                let start = DateHelper.startOfDay(day)
                let end = DateHelper.endOfDay(day)
                let s = vm.clientDetails.reduce(0.0) { acc, item in
                    if let d = item.date, d >= start && d <= end {
                        return acc + Double(item.price)
                    }
                    return acc
                }
                let label = DateFormatter.dayShortFormatter.string(from: day) // e.g., 21, 22
                return BarChartDataPoint(label: label, value: s)
            }

        case .monthly:
            // show daily totals of the selected month
            let days = DateHelper.daysInMonth(containing: selectedDate)
            return days.map { day in
                let start = DateHelper.startOfDay(day)
                let end = DateHelper.endOfDay(day)
                let s = vm.clientDetails.reduce(0.0) { acc, item in
                    if let d = item.date, d >= start && d <= end {
                        return acc + Double(item.price)
                    }
                    return acc
                }
                let label = String(DateHelper.calendar.component(.day, from: day))
                return BarChartDataPoint(label: label, value: s)
            }

        case .quarterly:
            guard let start = DateHelper.startOfQuarter(containing: selectedDate),
                  let end = DateHelper.endOfQuarter(containing: selectedDate) else { return [] }
            // group by month within quarter
            var months: [Date] = []
            var current = start
            while current <= end {
                months.append(current)
                guard let next = DateHelper.calendar.date(byAdding: .month, value: 1, to: current) else { break }
                current = next
            }
            return months.map { m in
                let sStart = DateHelper.startOfMonth(m) ?? m
                let sEnd = DateHelper.endOfMonth(m) ?? m
                let s = vm.clientDetails.reduce(0.0) { acc, item in
                    if let d = item.date, d >= sStart && d <= sEnd {
                        return acc + Double(item.price)
                    }
                    return acc
                }
                let label = DateFormatter.monthShortFormatter.string(from: m)
                return BarChartDataPoint(label: label, value: s)
            }
            
        case .half:
            guard let start = DateHelper.startOfHalfYearly(containing: selectedDate),
                  let end = DateHelper.endOfHalfYearly(containing: selectedDate) else { return [] }
            // group by month within quarter
            var months: [Date] = []
            var current = start
            while current <= end {
                months.append(current)
                guard let next = DateHelper.calendar.date(byAdding: .month, value: 1, to: current) else { break }
                current = next
            }
            return months.map { m in
                let sStart = DateHelper.startOfMonth(m) ?? m
                let sEnd = DateHelper.endOfMonth(m) ?? m
                let s = vm.clientDetails.reduce(0.0) { acc, item in
                    if let d = item.date, d >= sStart && d <= sEnd {
                        return acc + Double(item.price)
                    }
                    return acc
                }
                let label = DateFormatter.monthShortFormatter.string(from: m)
                return BarChartDataPoint(label: label, value: s)
            }


        case .yearly:
            guard let start = DateHelper.startOfYear(selectedDate),
                  let end = DateHelper.endOfYear(selectedDate) else { return [] }
            var months: [Date] = []
            var current = start
            while current <= end {
                months.append(current)
                guard let next = DateHelper.calendar.date(byAdding: .month, value: 1, to: current) else { break }
                current = next
            }
            return months.map { m in
                let sStart = DateHelper.startOfMonth(m) ?? m
                let sEnd = DateHelper.endOfMonth(m) ?? m
                let s = vm.clientDetails.reduce(0.0) { acc, item in
                    if let d = item.date, d >= sStart && d <= sEnd {
                        return acc + Double(item.price)
                    }
                    return acc
                }
                let label = DateFormatter.monthShortFormatter.string(from: m)
                return BarChartDataPoint(label: label, value: s)
            }

        case .all:
            // group by year (or month). Here we show yearly totals for last 5 years
            var years: [Int] = []
            let thisYear = DateHelper.calendar.component(.year, from: selectedDate)
            for i in (0..<5).reversed() {
                years.append(thisYear - i)
            }
            return years.map { y in
                var comps = DateComponents()
                comps.year = y
                comps.month = 1
                comps.day = 1
                let start = DateHelper.calendar.date(from: comps) ?? Date()
                let end = DateHelper.calendar.date(byAdding: .year, value: 1, to: start)?.addingTimeInterval(-1) ?? start
                let s = vm.clientDetails.reduce(0.0) { acc, item in
                    if let d = item.date, d >= start && d <= end {
                        return acc + Double(item.price)
                    }
                    return acc
                }
                return BarChartDataPoint(label: "\(y)", value: s)
            }
        }
    }

    private func displayedTransactions() -> [NewClient] {
        // simple: show items in selected period, latest first
        switch period {
        case .daily:
            let start = DateHelper.startOfDay(selectedDate)
            let end = DateHelper.endOfDay(selectedDate)
            return vm.clientDetails.filter { item in
                if let d = item.date { return d >= start && d <= end }
                return false
            }.reversed()
        case .monthly:
            guard let start = DateHelper.startOfMonth(selectedDate),
                  let end = DateHelper.endOfMonth(selectedDate) else { return [] }
            return vm.clientDetails.filter { item in
                if let d = item.date { return d >= start && d <= end }
                return false
            }.reversed()
        case .quarterly:
            guard let start = DateHelper.startOfQuarter(containing: selectedDate),
                  let end = DateHelper.endOfQuarter(containing: selectedDate) else { return [] }
            return vm.clientDetails.filter { item in
                if let d = item.date { return d >= start && d <= end }
                return false
            }.reversed()
        case .half:
            guard let start = DateHelper.startOfHalfYearly(containing: selectedDate),
                  let end = DateHelper.endOfHalfYearly(containing: selectedDate) else { return [] }
            return vm.clientDetails.filter { item in
                if let d = item.date { return d >= start && d <= end }
                return false
            }.reversed()

        case .yearly:
            guard let start = DateHelper.startOfYear(selectedDate),
                  let end = DateHelper.endOfYear(selectedDate) else { return [] }
            return vm.clientDetails.filter { item in
                if let d = item.date { return d >= start && d <= end }
                return false
            }.reversed()
        case .all:
            return vm.clientDetails.reversed()
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                BackGround()
            
                ScrollView {
                    VStack(spacing: 16) {
                        // summary row
                        VStack {
                            
                    Text("TOTAL SUMMARY").font(.headline).foregroundColor(.black)
                            
                        }
                        
                        VStack(spacing: 12)
                        {
                            SummaryCard(title: "Today", amount: totalForToday())
                            SummaryCard(title: "Monthly", amount: totalForMonth())
                            SummaryCard(title: "Yearly", amount: totalForYear())
                        }
                        .padding(.horizontal)
                        
                        // segmented control + date picker
                        VStack(spacing: 5) {
                            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                                .labelsHidden()
                                .padding(.horizontal)

                            Picker("Period", selection: $period) {
                                ForEach(ReportPeriod.allCases, id: \.self) { p in
                                    Text(p.rawValue).tag(p)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                            
                        }
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                       // .shadow(color: Color.black, radius: 0.2, y: 0.2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black.opacity(0.5))
                        )
                        .padding()
                       // .cornerRadius(10)
                        // chart
                        VStack {
                            let data = chartData(for: period)
                            BarChartView(values: data)
                                .padding(.horizontal)
                        }
                        
                        // transactions list
                        VStack(alignment: .leading, spacing: 0) {
                           // Text("Name").font(.title3).bold().padding(.leading)
                            ForEach(displayedTransactions(), id: \.self) { client in
                                HStack {
                                    Spacer()
                                    Text(client.name ?? "").padding(.leading)
                                    Spacer()
                                    Text(client.type ?? "").foregroundColor(.secondary)
                                    Text("  ")
                                    Text("₹\(Int(client.price))").bold().padding(.trailing)
                                    Spacer()

                                }
                                .padding(.vertical, 12)
                                Divider()
                            }
                        }
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                       // .shadow(color: Color.black, radius: 0.2, y: 0.2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black.opacity(0.5))
                        )
                       // .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                    .padding(.top)
                }// ZStack
            }
            //.navigationTitle("Reports")
            .onAppear {
                // ensure vm has fetched data
                vm.fetchCartItems()
            }
        }
    }
}

struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView()
    }
}

// date formatter extensions
extension DateFormatter {
    static let dayShortFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d" // day number
        return f
    }()
    static let monthShortFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM"
        return f
    }()
}
