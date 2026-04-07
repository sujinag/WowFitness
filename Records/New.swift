//
//  New.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 04/11/25.
//

import SwiftUI
import Charts
struct New: View {
    @State private var isShowPopUp = false
    @EnvironmentObject var viewModel: DatabaseCombine  // ✅ Access shared ViewModel
      var array = [1,2,3,4,5]
    @State private var name: String = ""
    @State private var age: String = "" // Use String for TextField input, convert to Int later for validation/storage

    var body: some View
    {

        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    // Name input
                        TextField("Enter your name", text: $name)
                    
                    
                    // Age input (using UIKeyboardType.numberPad for better user experience)
                    TextField("Enter your age", text: $age)
                        .keyboardType(.numberPad)
                    
                    // Gender picker
                }
                
                Section(header: Text("Personal Information")) {
                    // Name input
                        TextField("Enter your name", text: $name)
                    
                    
                    // Age input (using UIKeyboardType.numberPad for better user experience)
                    TextField("Enter your age", text: $age)
                        .keyboardType(.numberPad)
                    
                    // Gender picker
                }

            }

        VStack
        {
            Text("hello world")
                .frame(width: 100,height: 100)


        } //vStack
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    EditButton()
                }
                ToolbarItem {


                    Button(action:
                    {
                        isShowPopUp = true
                    })
                    {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)

                    }
                }

            } //toolBar

            .sheet(isPresented: $isShowPopUp) {
                AddNewClient(isPresented: $isShowPopUp)
                    .environmentObject(viewModel)

            }

            } //NavStack
        
       
        
    }
   /* NavigationView {
               VStack {
                   Text("hello world")
                       .frame(width: 100, height: 100)
               }
               .toolbar {
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Button(action: {
                           isShowPopUp = true
                       }) {
                           Image(systemName: "plus")
                               .font(.system(size: 20))
                               .foregroundColor(.blue)
                       }
                   }
               }
               // ✅ Attach sheet here to VStack (or .navigationViewStyle)
               .sheet(isPresented: $isShowPopUp) {
                   AddNewClient(isPresented: $isShowPopUp)
               }
           }
           // Optional but sometimes needed in iOS 16+
           .navigationViewStyle(StackNavigationViewStyle())
       } */
}
private func addItem()
{
    withAnimation {}
    
}
struct New_Previews: PreviewProvider {
    static var previews: some View {
        New()
    }
}
