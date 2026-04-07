//
//  ExpensesCard.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 30/12/25.
//

import SwiftUI

struct ExpensesCard: View {
    let title: String
    let amount: Double
    let currencyPrefix: String = "₹" // change as needed

    var body: some View {
        VStack(spacing: 8) {
            Text(title).font(.subheadline).foregroundColor(.secondary)
            Text("\(currencyPrefix)\(Int(amount).formattedWithSeparator())")
                .font(.title2).bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.green.opacity(0.8), radius: 4, x: 0, y: 2)
    }
}

// nice thousands separator helper
extension Int {
    func formattedExpensesSeparator() -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
