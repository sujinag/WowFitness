
import SwiftUI

struct BarChartDataPoint {
    let label: String
    let value: Double
}

struct BarChartView: View {
    let values: [BarChartDataPoint]    // values in order
    var maxValue: Double? = nil        // optional override
    var barColor: Color = Color(#colorLiteral(red: 0.121, green: 0.737, blue: 0.654, alpha: 1)) // teal-like

    var body: some View {
        GeometryReader { geo in
            VStack {
                // Y axis labels (simple)
                HStack(alignment: .top) {
                    VStack {
                        // three ticks: top, middle, 0
                        let top = (maxValue ?? values.map({ $0.value }).max() ?? 1)
                        Text("\(Int(top))")
                        Spacer()
                        Text("\(Int(top/2))")
                        Spacer()
                        Text("0")
                    }
                    .font(.caption)
                    .frame(width: 40)

                    // Chart bars
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom, spacing: 12) {
                            ForEach(0..<values.count, id: \.self) { i in
                                let v = values[i].value
                                let maxV = maxValue ?? (values.map({ $0.value }).max() ?? 1)
                                let heightRatio = (maxV == 0) ? 0 : v / maxV
                                VStack {
                                    // bar
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(barColor)
                                        .frame(width: 28, height: max(4, CGFloat(heightRatio) * (geo.size.height * 0.5)))
                                    // label
                                    Text(values[i].label).font(.caption)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                    }
                }
            } // VStack
            .background(.white.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 12))
           // .shadow(color: Color.black, radius: 0.2, y: 0.2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.5))
            )

        }
        .frame(height: 280)
    }
}
