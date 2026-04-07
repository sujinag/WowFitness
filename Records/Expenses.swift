//
//  Expenses.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 29/12/25.
//

import SwiftUI

struct Expenses: View {
    @StateObject var vm = DatabaseCombine()
    @State private var selectedDate: Date = Date()

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
    
    

    var body: some View {
        ScrollView
        {
            VStack {
                
                ExpensesCard(title: "Total Amount", amount: totalForYear())
            }
            .padding()
        }
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        Expenses()
    }
}
