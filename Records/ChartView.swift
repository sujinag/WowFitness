//
//  ChartView.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 27/11/25.
//

import SwiftUI

struct ChartView: View {
    var values: [Int]

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            ForEach(values, id: \.self) { val in
                Rectangle()
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 20, height: CGFloat(val))
            }
        }
        .frame(height: 200)
        .padding(.vertical)
    }
}
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(values: [0])
    }
}
