//
//  WatermarkBackground.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 13/11/25.
//

import SwiftUI

struct WatermarkBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            
            // Centered watermark image
            Image("wowLogo")
                .resizable()
                .scaledToFit()
               // .frame(width: 250, height: 250) // adjust size if needed
                .opacity(0.05) // controls how faint it looks
                .allowsHitTesting(false) // don’t block buttons or text
        }
        .background(Color.black.opacity(0.03)) // optional subtle tint
        .ignoresSafeArea()
    }
}

extension View
{
    func watermarkBackground() -> some View {
        self.modifier(WatermarkBackground())
    }
}

