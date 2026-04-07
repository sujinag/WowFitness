//
//  BackGround.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 19/03/26.
//

import SwiftUI
struct MybackGround: ViewModifier {

    func body(content: Content) -> some View
    {
        content
            .background(.white.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 12))
           // .shadow(color: Color.black, radius: 0.2, y: 0.2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.5))
            )
    }

}

struct BackGround: View {
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
            // .scaledToFill()
                .ignoresSafeArea()
            //.blur(radius: 8) // reduce from 10–15
        }
    }
    
}

struct BackGround_Previews: PreviewProvider {
    static var previews: some View {
        BackGround()
    }
}
