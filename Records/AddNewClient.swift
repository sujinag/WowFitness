//
//  AddNewClient.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 11/11/25.
//

import SwiftUI

struct AddNewClient: View {
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var mobileNum = ""
    @State private var gender = ""
    @State private var type = ""
   // @State private var photo
    @State private var clientId = 77
  //  @StateObject private var dataBaseCombine = DatabaseCombine()
    let fixedScreenBounds = UIScreen.main.fixedCoordinateSpace.bounds
    let color = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0,alpha: 1.0)
   // @EnvironmentObject var viewModel: DatabaseCombine  // ✅ Access shared ViewModel
    @StateObject private var dataBaseCombine = DatabaseCombine()
    @Environment(\.managedObjectContext) private var viewContext
    var genders = ["Male", "Female", "Other"]
    var typeOfTraining = ["General", "Personal Training"]
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false



    var body: some View {
        ScrollView {
            VStack
            {
                HStack
                {
                    LogoView()
                }
                
            }
            
            VStack(spacing: 1)
            {
                HStack
                {
                    
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                    //.background(Color.gray.opacity(0.8))
                    //.clipShape(Circle())
                    // .padding()
                    
                    TextField("Name",text: $name)
                        .padding(23)
                }
                //                    .overlay(
                //                        RoundedRectangle(cornerRadius: 9) // Create a rounded rectangle for the border
                //                            .stroke(Color(color), lineWidth: 1.0) // Define the border color and width
                //
                //                    )
                // Add padding around the text field and its
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.9), radius: 11, x: 0, y: 5)
                )
                .padding()
                
                HStack
                {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                    //.background(Color.gray.opacity(0.8))
                    //.clipShape(Circle())
                    // .padding()
                    
                    TextField("MobileNumber", text: $mobileNum)
                        .padding(23) // Add some padding inside the text field
                    
                }
                //                .overlay(
                //                    RoundedRectangle(cornerRadius: 9) // Create a rounded rectangle for the border
                //                        .stroke(Color(color), lineWidth: 1.0) // Define the border color and width
                //                )
                //                .padding() // Add padding around the text field and its
                
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.9), radius: 11, x: 0, y: 5)
                )
                .padding()
                
                
              //  trainingType()
              //  genderType()
                VStack(alignment: .leading) {
                    Text("Training type")
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    Picker("Select Gender", selection: $gender) {
                        ForEach(typeOfTraining, id: \.self) { g in
                            Text(g)
                                .foregroundColor(.black)
                        }
                    }
                    .pickerStyle(.segmented)
                    .font(.headline)
                }
            
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.15), radius: 8, x: 0, y: 5)
            )

                VStack(alignment: .leading) {
                    Text("Gender")
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    Picker("Select Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { g in
                            Text(g)
                                .foregroundColor(.black)
                        }
                    }
                    .pickerStyle(.segmented)
                    .font(.headline)
                }
            
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.15), radius: 8, x: 0, y: 5)
            )
        

                HStack {
                    
                    Button{
                        showImagePicker = true
                    } label: {
                        ZStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .font(.system(size: 40))
                                            .foregroundColor(.black)
                                    )
                            }
                        } //ZStack
                        
//                        Image("addImage")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50) // adjust size if
                    }
//                    .background(.white.opacity(0.75))
//                    .cornerRadius(9)
//                    .clipShape(Circle())
//
                    Spacer()
                    Button{
////                        dataBaseCombine.addItem(nameStr: name, mobNumStr: mobileNum, genderStr: gender, typeStr: type,  clientIDStr: Int16(clientId), photo: selectedImage)
//                        print("SavedData:",dataBaseCombine.clientDetails.reversed().enumerated().map({ $0.element.name}))
                        
                    } label: {
                        Image("correct")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80) // adjust size if needed
                            //.opacity(0.05) // controls how faint it looks
                          //  .allowsHitTesting(false) // don’t block buttons or text

//                            .foregroundColor(.white)
//                            .frame(width: 75, height: 75)
//                        Text("Save")
//                            .foregroundColor(.white)
//                            .font(.custom("times-bold", size: fixedScreenBounds.width / 20))
//                            .padding()
//                            .frame(width: fixedScreenBounds.width / 2.15,alignment: .center)

                    }
                    .background(.white.opacity(0.75))
                    .cornerRadius(9)
                    .clipShape(Circle())
                    //.bold()
                    Spacer()
                    Button{
                        isPresented = false
                    }label:{
                         Image("close")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 70, height: 70) // adjust size if
                    }

                }
                .padding()
                Spacer()
                
            .sheet(isPresented: $showImagePicker)
            {
                ImagePicker(selectedImage: $selectedImage)
            }

                
            } //VStack
           // .watermarkBackground()
        }
    }
}

struct trainingType: View {
    
    @State var trainingTypeExpand = false
    
    var body: some View{
        Button(action:
                {
            withAnimation
            {
                trainingTypeExpand.toggle()
            }
            
        })
        {
            HStack
            {
                // Spacer()
                Text("Training Type")
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .padding()
                //.frame(width: UIScreen.main.bounds.width-90,height: 70)
                Spacer()
                Image(systemName:"chevron.right").foregroundColor(.gray)
                    .rotationEffect(.degrees(trainingTypeExpand ? -90 : 0))
                    .padding(.trailing)
                // Spacer()
            }
            // .background(Rectangle() .strokeBorder(Color.gray,lineWidth: 1.0))
            
        }
        .padding()
        if trainingTypeExpand{
            
                        VStack //lastUpdateExpand Vstack
                        {
                            ZStack
                            {
                RoundedRectangle(cornerRadius: 10).foregroundColor(.white)
                   // .frame(width: UIScreen.main.bounds.width-9)
//                ScrollView(.vertical,showsIndicators: false)
//                {
//                    VStack(spacing: 14)
//                    {
//
//                    }//VStack
//                       .padding()
//
//
//                    } //ScrollView


                    } //ZStack
                          //  .offset(y: 5)
                    // .frame(height: 200) //Round view height


                    }.padding()
            
                
        } //Expand
        
    }

}


struct genderType: View {
    
    @State var genderTypeExpand = false
    
    var body: some View{
        Button(action:
                {
            withAnimation
            {
                genderTypeExpand.toggle()
            }
            
        })
        {
            HStack
            {
                // Spacer()
                Text("Gender")
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .padding()
                //.frame(width: UIScreen.main.bounds.width-90,height: 70)
                Spacer()
                Image(systemName:"chevron.right").foregroundColor(.gray)
                    .rotationEffect(.degrees(genderTypeExpand ? -90 : 0))
                    .padding(.trailing)
                // Spacer()
            }
            // .background(Rectangle() .strokeBorder(Color.gray,lineWidth: 1.0))
            
        }
        .padding()
        if genderTypeExpand{
            
                        VStack //lastUpdateExpand Vstack
                        {
                            ZStack
                            {
                RoundedRectangle(cornerRadius: 10).foregroundColor(.white)
                   // .frame(width: UIScreen.main.bounds.width-9)
//                ScrollView(.vertical,showsIndicators: false)
//                {
//                    VStack(spacing: 14)
//                    {
//
//                    }//VStack
//                       .padding()
//
//
//                    } //ScrollView


                    } //ZStack
                          //  .offset(y: 5)
                    // .frame(height: 200) //Round view height


                    }.padding()
            
                
        } //Expand
        
    }

}
// MARK: - Image Picker UIKit Wrapper
struct ImagePicker: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }
}
struct AddNewClient_Previews: PreviewProvider {
    static var previews: some View {
        AddNewClient(isPresented: .constant(true))
    }
}
