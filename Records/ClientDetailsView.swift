//
//  ClientDetailsView.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 19/11/25.
//

import SwiftUI

struct ClientDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var name: String
    @State  var gender: String
    @State  var mobileNumber: String
    @State  var type: String
    @State  var joiningDate: String
    @State var idStr:UUID
    @State var trainer:String
    let fixedScreenBounds = UIScreen.main.fixedCoordinateSpace.bounds
    @State private var selectedImage: UIImage? = nil
    @State  var savedImage: UIImage
    @State  var photoUrl: String


    @State private var showImagePicker = false
    @State private var isEditing = false
    @StateObject private var dataBaseCombine = DatabaseCombine()
    @State private var clientId = 77
    @State  var amountPaid:Int32
    @State  var package:String
    @State  var dueDate: String
    @State  var status: String
    @State private var showSaveSuccess = false
    @State private var showSaveError = false
    @State private  var priceUpdate: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var isPackageSelectionDone = false

    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }()


   // let genders = ["Male", "Female", "Other"]
    var body: some View {

        ZStack{
            BackGround()
            
            NavigationView {
                ScrollView {
                    HStack{
                        Spacer()
                        Button {
                            isEditing.toggle()
                            
                        } label: {
                            Text(isEditing ? "Done" : "Edit")
                        }
                    }
                    .padding()
                    VStack(spacing: 30) {
                        
                        // ───────────────
                        // PROFILE PHOTO
                        // ───────────────
                        // VStack {
                        if !isEditing {
                            
                            if let url = URL(string: photoUrl),UIApplication.shared.canOpenURL(url) {
                                AsyncImage(url: url ) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let img):
                                        img
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                    case .failure:
                                        Image(systemName: "photo")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                            }
                            // Below code to save image in to COREDATA
                            //                        Button {
                            //                            showImagePicker = true
                            //                        } label: {
                            //                            ZStack {
                            //                                if let image = savedImage {
                            //                                    Image(uiImage: image)
                            //                                        .resizable()
                            //                                        .scaledToFill()
                            //                                        .frame(width: 120, height: 120)
                            //                                        .clipShape(Circle())
                            //                                } else {
                            //                                    Circle()
                            //                                        .fill(Color.gray.opacity(0.15))
                            //                                        .frame(width: 120, height: 120)
                            //                                        .overlay(
                            //                                            Image(systemName: "person.crop.circle.badge.plus")
                            //                                                .font(.system(size: 40))
                            //                                                .foregroundColor(.black)
                            //                                        )
                            //                                }
                            //                            } //ZStack
                            //                        }
                            // Below code to save image in to COREDATA Ends
                            
                            
                            //                        Text("Add Photo")
                            //                            .font(.subheadline)
                            //                            .foregroundColor(.black)
                            
                            //  }
                            //  .padding(.top, 20)
                            
                            
                            
                            // ────────────────────────────
                            // CONTACT STYLE FORM SECTIONS
                            // ────────────────────────────
                            
                            
                            VStack(spacing: 0) {
                                Group {
                                    // ==== Name Field (like Contacts App) ====
                                    VStack
                                    {
                                        ContactRow(label: "Name", content: {
                                            TextField("", text: $name)
                                                .textContentType(.name)
                                                .font(.body)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                            
                                        })
                                    }
                                    Divider().padding(.leading, 100)
                                    
                                    // ==== Gender Picker ====
                                    VStack
                                    {
                                        
                                        ContactRow(label: "Gender", content: {
                                            TextField("", text: $gender)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                            
                                        })
                                    }
                                    
                                    Divider().padding(.leading, 100)
                                    
                                    // ==== Mobile Number ====
                                    VStack
                                    {
                                        
                                        ContactRow(label: "Mobile", content: {
                                            TextField("", text: $mobileNumber)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                            
                                        })
                                    }
                                    
                                    Divider().padding(.leading, 100)
                                    
                                    // ==== Mobile Number ====
                                    VStack
                                    {
                                        
                                        ContactRow(label: "Package", content: {
                                            TextField("", text: $package)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                            
                                        })
                                    }
                                    
                                    Divider().padding(.leading, 100)
                                    
                                    // ==== Mobile Number ====
                                }
                                
                                Group {
                                    VStack
                                    {
                                        
                                        ContactRow(label: "Joined on", content: {
                                            TextField("", text: $joiningDate)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                        })
                                    }
                                    
                                    Divider().padding(.leading, 100)
                                    VStack
                                    {
                                        ContactRow(label: "Type", content: {
                                            TextField("", text: $type)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                        })
                                    }
                                    
                                    Divider().padding(.leading, 100)
                                    //
                                    VStack
                                    {
                                        ContactRow(label: "Trainer", content: {
                                            TextField("", text: $trainer)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                        })
                                    }
                                    
                                    Divider().padding(.leading, 100)
                                    
                                    VStack
                                    {
                                        ContactRow(label: "Amount", content: {
                                            TextField("", value: $amountPaid,formatter: numberFormatter)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                        })
                                    }
                                    VStack
                                    {
                                        ContactRow(label: "Due date", content: {
                                            TextField("", text: $dueDate)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                        })
                                    }
                                    
                                    VStack
                                    {
                                        ContactRow(label: "Status", content: {
                                            TextField("", text: $status)
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.gray)
                                                .disabled(true)
                                        })
                                    }
                                    
                                    
                                }
                                
                                
                            } //Contact VStack ends
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(color: Color.black.opacity(0.5), radius: 2, y: 2)
                            .padding(.horizontal)
                        } //ISEditing
                        else {
                            
                            editClientDetails()
                        }
                        
                        
                        
                    } //VStack main Ends here
                    .background(Color.clear)
                    .padding(.bottom, 40)
                    
                    VStack {
                        Button {
                            guard !name.isEmpty else {
                                alertMessage = "Name cannot be empty"
                                showAlert = true
                                return
                            }
                            
                            guard dataBaseCombine.isValidName(name) else {
                                alertMessage = "Enter a valid name"
                                showAlert = true
                                return
                            }
                            
                            guard !priceUpdate.isEmpty else {
                                alertMessage = "Price cannot be empty"
                                showAlert = true
                                return
                            }
                            guard dataBaseCombine.isValidMobile(mobileNumber) else {
                                alertMessage = "Enter a valid 10-digit mobile number"
                                showAlert = true
                                return
                            }
                            
                            
                            dataBaseCombine.updateItem(id: idStr, nameStr: name, mobNumStr: mobileNumber,trainerSave: dataBaseCombine.selectedTrainer.displayName,typeSave:dataBaseCombine.selectedTraining.displayName,packageSave: dataBaseCombine.selectedPackage.displayName,priceUpdate:Int32(priceUpdate) ?? 0 ,paymentStatus: dataBaseCombine.selectedPaymentStatus.displayName){ success in
                                
                                if success
                                {
                                    // ✅ Clear only when saved
                                    showSaveSuccess = true // For Alert
                                }
                                else
                                {
                                    // ❌ Keep values untouched
                                    print("Not saved — fields remain same")
                                    showSaveError = true
                                    
                                }
                            }
                            //}
                            
                            // dataBaseCombine.addItem(nameStr: name, mobNumStr: mobileNumber, genderStr: gender, typeStr: type,  clientIDStr: Int16(clientId),photo: selectedImage)
                            // print("SavedData:",dataBaseCombine.clientDetails.reversed().enumerated().map({ $0.element.name}))
                            
                        } label: {
                            //                    Image("correct")
                            //                        .resizable()
                            //                        .scaledToFit()
                            //                        .frame(width: 80, height: 80) // adjust size if needed
                            //                        //.opacity(0.05) // controls how faint it looks
                            //                      //  .allowsHitTesting(false) // don’t block buttons or text
                            //
                            ////                            .foregroundColor(.white)
                            ////                            .frame(width: 75, height: 75)
                            Text("Update")
                                .foregroundColor(.white)
                                .font(.custom("times-bold", size: fixedScreenBounds.width / 20))
                                .padding()
                                .frame(width: fixedScreenBounds.width / 3.15,alignment: .center)
                            
                            
                            
                        }
                        .background(.black.opacity(0.5))
                        .cornerRadius(6)
                        
                    } //Button Vstack
                    // .clipShape(Circle())
                    .background(Color.white.opacity(0.8))

                    .alert("ChangesSaved", isPresented: $showSaveSuccess){
                        Button("Ok",role: .cancel){
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }
                    }
                    .alert("Error", isPresented: $showSaveError){
                        Button("Ok",role: .cancel){}
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage))
                    }
                    
                    
                }//Scrollview
                .background(Color.clear)

                .onAppear{
                    priceUpdate = String(amountPaid)
                    if trainer == "Harish" {
                        dataBaseCombine.selectedTrainer = .harish
                    }
                    else{
                        dataBaseCombine.selectedTrainer = .abdul
                        
                    }
                    TypePickerIndexChange()
                    PackagePickerIndexChange()
                    PaymentStatusUpdate()
                    
                }
                
                // .navigationTitle("Client Details")
                //            .sheet(isPresented: $showImagePicker) {
                //                ImagePicker(selectedImage: $selectedImage)
                //            }
                //                    .onAppear
                //                    {
                //                        priceUpdate = Int16(amountPaid)
                //                    }
                
                
            }//NavView
            .background(Color.clear)

        } //ZStack
        .background(Color.clear)

        
    } //Body ends here
    
    func PaymentStatusUpdate(){
        
        if status.lowercased() == "paid"{
            dataBaseCombine.selectedPaymentStatus = .paid
        }
        else {
            dataBaseCombine.selectedPaymentStatus = .unPaid
        }
    }
    func TypePickerIndexChange(){
        if type == "General" {
            dataBaseCombine.selectedTraining = .general
        }
        else {
            dataBaseCombine.selectedTraining = .personal
        }
    }
    func PackagePickerIndexChange() {
        if package.lowercased() == "monthly"{
            dataBaseCombine.selectedPackage = .monthly
            
        }
        else if package.lowercased() == "quarterly"{
            dataBaseCombine.selectedPackage = .quarterly

        }
        else if package.lowercased() == "halfyearly"{
            dataBaseCombine.selectedPackage = .halfYearly

        }
        else{
            dataBaseCombine.selectedPackage = .annual

        }
        
    }
    
    func editClientDetails() -> some View
    {
        VStack(spacing: 0)
        {
            
            Group {
                // ==== Name Field (like Contacts App) ====
                HStack {
                    ContactRow(label: "Name", content: {
                        TextField("name", text: $name)
                            .keyboardType(.numberPad)
                    })
                    Spacer()
                }
                
                ContactRow(label: "Mobile", content: {
                    TextField("Phone Number", text: $mobileNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: mobileNumber) { newValue in
                            // Allow only numbers
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            
                            // Limit to 10 digits
                            if filtered.count > 10 {
                                mobileNumber = String(filtered.prefix(10))
                            } else {
                                mobileNumber = filtered
                            }
                        }
                })
                //  }
                
                Divider().padding(.leading, 100)
                HStack {
                    ContactRow(label: "Payment", content:
                                {
                        Picker("Payment",selection: $dataBaseCombine.selectedPaymentStatus)
                        {
                            ForEach(PaymentStatus.allCases){ t in
                                Text(t.displayName).tag(t)

                            }
                        }
                        //.disabled(dataBaseCombine.selectedPaymentStatus == .paid)// it immediately disables picker
                    })
                    Spacer()
                }
                
                 
                
                Divider().padding(.leading, 100)
                // ==== PACKAGE ====
            } // COntact group Group Ends
            
            
            //  Group {
            HStack { //$dataBaseCombine.selectedPackage
                ContactRow(label: "Package", content: {
                    Picker("Package",selection: $dataBaseCombine.selectedPackage){
                        ForEach(PackageType.allCases){ p in
                            Text(p.displayName).tag(p)
                            
                        }
                        
                    }
                    .onChange(of: dataBaseCombine.selectedPackage) { _ in
                        isPackageSelectionDone = true
                    }
                    
                })
                Spacer()
            }
            
            Divider().padding(.leading, 100)
            
            HStack {
                ContactRow(label: "Type", content:
                            {
                    Picker("Type",selection: $dataBaseCombine.selectedTraining)
                    {
                        ForEach(TrainingType.allCases){ t in
                            Text(t.displayName).tag(t)
                            
                        }
                    }
                })
                Spacer()
            } // Type HStack ends here
            Divider().padding(.leading, 100)
            HStack {
                ContactRow(label: "Trainer", content:
                            {
                    Picker("Type",selection: $dataBaseCombine.selectedTrainer)
                    {
                        ForEach(TrainerType.allCases){ t in
                            Text(t.displayName).tag(t)
                            
                        }
                    }
                })
                Spacer()
            }
            // }
            
            Divider().padding(.leading, 100)
            
            
            HStack
            {
                ContactRow(label: "Price", content: {
                   // Text("\(dataBaseCombine.computedPrice)")
                    //priceUpdate = Int16(amountPaid)
                   TextField("Price", text: $priceUpdate)
                  //  TextField("", value: $amountPaid,formatter: numberFormatter)
                        .keyboardType(.numberPad)
                       // .disabled(!isPackageSelectionDone)
                        .opacity(isPackageSelectionDone ? 1 : 0.8)
                        .onChange(of: priceUpdate) { newValue in
                            // Allow only numbers
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            
                            // Limit to 10 digits
                            if filtered.count > 5 {
                                priceUpdate = String(filtered.prefix(5))
                            } else {
                                priceUpdate = filtered
                            }
                        }

                })
                Spacer()
            }
            
            
            // } //Group Ends here
            
        } //Contact VStack ends
        
        .background(Color.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black, radius: 4, y: 2)
        .padding(.horizontal)
        //.padding(.bottom, 40)
        
    }
}



//// MARK: - Contact Row (Styled like iOS Contacts)
//struct ContactRow<Content: View>: View {
//    let label: String
//    let content: () -> Content
//
//    var body: some View {
//        HStack(spacing: 20) {
//            Text(label)
//                .frame(width: 80, alignment: .leading)
//                .foregroundColor(.black)
//                .font(.headline)
//
//            content()
//        }
//        .padding(.horizontal)
//        .frame(height: 55)
//    }
//}


// MARK: - Image Picker UIKit Wrapper
//struct ImagePicker: UIViewControllerRepresentable {
//
//    @Binding var selectedImage: UIImage?
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: ImagePicker
//        init(_ parent: ImagePicker) { self.parent = parent }
//
//        func imagePickerController(_ picker: UIImagePickerController,
//                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.selectedImage = image
//            }
//            picker.dismiss(animated: true)
//        }
//    }
//}



struct ClientDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientDetailsView(name: "", gender: "",mobileNumber: "" , type: "",joiningDate: "", idStr:  UUID(), trainer: "", savedImage: UIImage(), photoUrl: "", amountPaid: 0, package: "",dueDate: "", status: "")
    }
}

struct EditClientDetailsForm: View {
    @StateObject private var dataBaseCombine = DatabaseCombine()
    @State private var name: String = ""
    @State private var mobileNumber: String = ""

    var body: some View {
        
            VStack(spacing: 0)
            {
                
                Group {
                    // ==== Name Field (like Contacts App) ====
                    HStack {
                        ContactRow(label: "Name", content: {
                            TextField("name", text: $name)
                                .keyboardType(.numberPad)
                        })
                        Spacer()
                    }
                    
                    ContactRow(label: "Mobile", content: {
                        TextField("Phone Number", text: $mobileNumber)
                            .keyboardType(.numberPad)
                            .onChange(of: mobileNumber) { newValue in
                                // Allow only numbers
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                
                                // Limit to 10 digits
                                if filtered.count > 10 {
                                    mobileNumber = String(filtered.prefix(10))
                                } else {
                                    mobileNumber = filtered
                                }
                            }
                    })
                    //  }
                    
                    Divider().padding(.leading, 100)
                    HStack {
                        ContactRow(label: "Gender", content:
                                    {
                            Picker("Gender",selection: $dataBaseCombine.selectedGender)
                            {
                                ForEach(GenderType.allCases){ t in
                                    Text(t.displayName).tag(t)
                                    
                                }
                            }
                        })
                        Spacer()
                    }
                    
                    // }
                    
                    Divider().padding(.leading, 100)
                    // ==== PACKAGE ====
                } // COntact group Group Ends
                
                
                //  Group {
                HStack { //$dataBaseCombine.selectedPackage
                    ContactRow(label: "Package", content: {
                        Picker("Package",selection: $dataBaseCombine.selectedPackage){
                            ForEach(PackageType.allCases){ p in
                                Text(p.displayName).tag(p)
                                
                            }
                            
                        }
                        
                    })
                    Spacer()
                }
                
                Divider().padding(.leading, 100)
                
                HStack {
                    ContactRow(label: "Type", content:
                                {
                        Picker("Type",selection: $dataBaseCombine.selectedTraining)
                        {
                            ForEach(TrainingType.allCases){ t in
                                Text(t.displayName).tag(t)
                                
                            }
                        }
                    })
                    Spacer()
                } // Type HStack ends here
                Divider().padding(.leading, 100)
                HStack {
                    ContactRow(label: "Trainer", content:
                                {
                        Picker("Type",selection: $dataBaseCombine.selectedTrainer)
                        {
                            ForEach(TrainerType.allCases){ t in
                                Text(t.displayName).tag(t)
                                
                            }
                        }
                    })
                    Spacer()
                }
                // }
                
                Divider().padding(.leading, 100)
                
                
                HStack
                {
                    ContactRow(label: "Price", content: {
                        Text("\(dataBaseCombine.computedPrice)")
                    })
                    Spacer()
                }
                
                
                // } //Group Ends here
                
            } //Contact VStack ends
            
            
        
    }
}
