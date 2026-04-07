//
//  LogoView.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 18/11/25.
//

import SwiftUI


struct LogoView: View {
    @State var isLabelClicked = false

    var body: some View {
        HStack
        {
            Spacer()
            Image("wowLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100,height: 100)
            //Text(isLabelClicked ? "+91 7207208166" : "Work out World \n Fitness")
             //   .font(.headline)
              //  .fontDesign(.serif)
               // .fontWeight(.heavy)
            // .foregroundColor(Color(red: 216/255.0, green: 0/255.0, blue: 38/255.0))
              //  .foregroundColor(Color.black)
                .onTapGesture {
                    isLabelClicked.toggle()
                    
                }

            Spacer()

        } //HStack
    }
}


struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
