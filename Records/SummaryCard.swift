import SwiftUI

struct SummaryCard: View {
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
        .background(.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 12))
       // .shadow(color: Color.black, radius: 0.2, y: 0.2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.5))
        )
       // .padding(.horizontal)
       // .padding(.bottom, 40)

//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: Color.green.opacity(0.8), radius: 4, x: 0, y: 2)
    }
}

// nice thousands separator helper
extension Int {
    func formattedWithSeparator() -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","
        return f.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
