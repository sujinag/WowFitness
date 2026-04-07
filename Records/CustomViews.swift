//
//  CustomViews.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 20/11/25.
//

import Foundation
import SwiftUI
// MARK: - Contact Row (Styled like iOS Contacts)
 struct ContactRow<Content: View>: View {
    let fixedScreenBounds = UIScreen.main.fixedCoordinateSpace.bounds
    let label: String
    let content: () -> Content

    var body: some View {
        HStack(spacing: 20) {
            Text(label)
                .frame(width: 150, alignment: .leading)
                .foregroundColor(.black)
                .font(.custom("times-bold", size: fixedScreenBounds.width / 20))
                .padding()

            content()
        }
        .padding(.horizontal)
        .frame(height: 55)
    }
}
