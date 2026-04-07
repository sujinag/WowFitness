//
//  AddClient.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 20/11/25.
//

import SwiftUI

struct AddClient: View {
    @State private var name: String = ""
    @State private var gender: String = "Male"
    @State private var mobileNumber: String = ""
    @State private var type: String = "General"
    @State private var trainerStr: String = "Abdul"
    @State private var joiningDate: String = ""
    @State  var packageStr: String = "Monthly"
    @State private var showSaveSuccess = false
    @State private var showSaveError = false
    @State private  var price: String = ""
    @State private var photoUrl: String = ""
    @State private var showAlert = false
    //private(set) var computedPrice: Int = 0
    @State private var alertMessage: String = ""
    @State private var showMail = false
    @State private var savedClientEmail = ""



    let fixedScreenBounds = UIScreen.main.fixedCoordinateSpace.bounds
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @StateObject private var dataBaseCombine = DatabaseCombine()
    @State  var clientId:Int32

    let genders = ["Male", "Female", "Other"]
    let packagesArr = ["Monthly","Quarterly","HalfYearly","Annual"]
    let pricesArr = [1000,3000,20000,30000]

    let typeArr = ["General","Personal"]
    let trainerArr = ["Abdul","Harish"]
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    enum pricesEnum: Int
    {
        
        case annual = 36000
        case monthly = 3000
        case quarterly = 10000
        case halfYearly = 20000
    }
//    let packages = packageStr.lowercased()
//    let types = type.lowercased()


    fileprivate func resetForm() {
        // ✅ Clear only when saved
        name = ""
        mobileNumber = ""
        photoUrl = ""
        selectedImage = nil
        showSaveSuccess = true // For Alert
        dataBaseCombine.selectedPackage = .monthly
        dataBaseCombine.selectedTraining = .general
        dataBaseCombine.selectedGender = .male
        dataBaseCombine.selectedTrainer = .abdul
    }
    
    var body: some View {
        //NavigationView {
        ZStack{
            
            BackGround()

            ScrollView {
                
                //                VStack
                //                {
                
                //}
                VStack(spacing: 0) {
                    HStack
                    {
                        LogoView()
                    }
                    
                    // ───────────────
                    // PROFILE PHOTO
                    // ───────────────
                    //  VStack {
                    
                    //Enable this button for picking image from DB//
                    
                    /* Button {
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
                     
                     }*/
                   // TextField("Photo link(Optional)", text: $photoUrl)
                     //   .foregroundColor(.black)
                    TextField("", text: $photoUrl, prompt: Text("Photo URL(Optional)")
                        .foregroundColor(.blue.opacity(0.7)) // Custom placeholder color
                        )
                        .multilineTextAlignment(.center)
                        .frame(height: fixedScreenBounds.width * 0.11)
                              
                        .font(.body)
                              
                        .background(.white.opacity(0.6))

                       // .textFieldStyle(.roundedBorder)
                       // .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0.5))
                        )

                      //  .shadow(color: Color.black, radius: 0.5, y: 1)
                      
                        .padding()
                    // Add a visible border
                    
                    
                    //                        Text("Add Photo")
                    //                            .font(.custom("times-bold", size: fixedScreenBounds.width / 20))
                    //                            .foregroundColor(.black)
                    
                    // .disableAutocorrection(true)
                    
                    //                    }
                    //                    .padding(.top, 20)
                    
                } //VStackMain ends here
                
                // ────────────────────────────
                // CONTACT STYLE FORM SECTIONS
                // ────────────────────────────
                VStack(spacing: 0)
                {
                    
                    Group {
                        // ==== Name Field (like Contacts App) ====
                        HStack {
                            ContactRow(label: "Name", content: {
                               // TextField("Enter Name", text: $name)
                                TextField("", text: $name, prompt: Text("Enter Name").foregroundColor(.black.opacity(0.6)))
                                    .keyboardType(.numberPad)



                            })
                            
                            //                                HStack {
                            //                                    Text("Name")
                            //                                        .frame(width: 120, alignment: .leading)
                            //                                        .foregroundColor(.black)
                            //                                        .font(.custom("times-bold", size: fixedScreenBounds.width / 20))
                            //                                        .padding()
                            //                                    Spacer()
                            //                                    //  ContactRow(label: "Name", content: {
                            //                                    TextField("Full Name", text: $name)
                            //                                        .textContentType(.name)
                            //                                        .font(.body)
                            //                                        .disableAutocorrection(true)
                            //                                }
                            Spacer()
                        }
                        
                        //  Divider().padding(.leading, 100)
                        //                            // ==== Mobile Number ====
                        // VStack {
                        ContactRow(label: "Mobile", content: {
                          //  TextField("Phone Number", text: $mobileNumber)
                            TextField("", text: $mobileNumber, prompt: Text("Enter Mobile Number").foregroundColor(.black.opacity(0.6)))

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
                        
                        
                        // ==== Gender Picker ====
                        //  VStack {
                        /* ContactRow(label: "Gender", content: {
                         Menu {
                         ForEach(genders, id: \.self) { gender in
                         Button(gender) { self.gender = gender }
                         }
                         } label: {
                         HStack {
                         Text(gender)
                         Spacer()
                         Image(systemName: "chevron.right")
                         .font(.caption)
                         .foregroundColor(.gray)
                         }
                         }
                         })*/
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
                        //
                        
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
                        //                                Image(systemName: "chevron.right")
                        //                                    .font(.caption)
                        //                                    .foregroundColor(.gray)
                        //
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
                            
                            
                            //                                    Menu {
                            //                                    ForEach(TrainingType.allCases){ t in
                            //                                        Text(t.displayName).tag(t)
                            //
                            //                                    }
                            //
                            ////                                        ForEach(typeArr, id: \.self) { typ in
                            ////                                            Button(typ) { self.type = typ }
                            ////                                        }
                            //                                    } label: {
                            //                                        HStack {
                            //                                            Text(dataBaseCombine.selectedTraining.displayName)
                            //                                            Spacer()
                            //                                            Image(systemName: "chevron.right")
                            //                                                .font(.caption)
                            //                                                .foregroundColor(.gray)
                            //                                        }
                            //                                    }
                            
                        })
                        Spacer()
                    } // Type HStack ends here
                    Divider().padding(.leading, 100)
                    
                    // VStack {
                    /*  ContactRow(label: "Trainer", content: {
                     Menu {
                     ForEach(trainerArr, id: \.self) { trainer in
                     Button(trainer) { self.trainerStr = trainer }
                     }
                     } label: {
                     HStack {
                     Text(trainerStr)
                     Spacer()
                     Image(systemName: "chevron.right")
                     .font(.caption)
                     .foregroundColor(.gray)
                     }
                     }
                     })*/
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
                            /*TextField("Price", text: $price)
                             .keyboardType(.numberPad)
                             .onChange(of: price) { newValue in
                             // Allow only numbers
                             let filtered = newValue.filter { "0123456789".contains($0) }
                             
                             // Limit to 10 digits
                             if filtered.count > 5 {
                             price = String(filtered.prefix(5))
                             } else {
                             price = filtered
                             }
                             }*/
                            
                        })
                        Spacer()
                    }
                    
                    
                    // } //Group Ends here
                    
                } //Contact VStack ends
                
               // .background(.ultraThinMaterial)
                .background(.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 12))
               // .shadow(color: Color.black, radius: 0.2, y: 0.2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.5))
                )
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                Button {
                    
                    guard !name.isEmpty else {
                        alertMessage = "Name cannot be empty"
                        showAlert = true
                        return
                    }
                    
                    guard dataBaseCombine.isValidName(name) else {
                        alertMessage = "Enter a valid name (A–Z only)"
                        showAlert = true
                        return
                    }
                    
                    guard dataBaseCombine.isValidMobile(mobileNumber) else {
                        alertMessage = "Enter a valid 10-digit mobile number"
                        showAlert = true
                        return
                    }
                    
                    if photoUrl.count > 0 {
                        guard dataBaseCombine.isValidImageUrl(photoUrl) else {
                            alertMessage = "Add a valid imageUrl"
                            showAlert = true
                            return
                            
                        }
                    }
                    
                    //                    guard !price.isEmpty else {
                    //                        alertMessage = "Price cannot be empty"
                    //                        showAlert = true
                    //                        return
                    //                    }
                    
                    
                    //                    guard dataBaseCombine.isValidPrice(price) else {
                    //                            alertMessage = "Enter a valid price (numbers only)"
                    //                            showAlert = true
                    //                            return
                    //                        }
                    
                    //Replacing packageStr to databasecombine.selctedpackage
                    // Replacing type to dataBaseCombine.selectedTraining.displayname
                    dataBaseCombine.addItem(nameSave: name, mobNumSave: mobileNumber, genderSave: dataBaseCombine.selectedGender.displayName, typeSave: dataBaseCombine.selectedTraining.displayName, photo: selectedImage, packageSave: dataBaseCombine.selectedPackage.displayName, trainerSave: dataBaseCombine.selectedTrainer.displayName, photoSaveLink: photoUrl,priceSave: Int32(price) ?? 0){ success in
                        
                        if success
                        {
                            resetForm()
                        }
                        else
                        {
                            // ❌ Keep values untouched
                            print("Not saved — fields remain same")
                            showSaveError = true
                            
                        }
                        
                    }
                    print("SavedData:",dataBaseCombine.clientDetails.reversed().enumerated().map({ $0.element.photo}))
                    
                } label: {
                    Image("correct")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80) // adjust size if needed
                    .opacity(0.8) // controls how faint it looks
                    //  .allowsHitTesting(false) // don’t block buttons or text
                    
                    //                            .foregroundColor(.white)
                    //                            .frame(width: 75, height: 75)
                    //                        Text("Update")
                    //                            .foregroundColor(.white)
                    //                            .font(.custom("times-bold", size: fixedScreenBounds.width / 20))
                    //                            .padding()
                    //                            .frame(width: fixedScreenBounds.width / 2.15,alignment: .center)
                    
                }
                .background(.white.opacity(0.35))
                .cornerRadius(9)
                .clipShape(Circle())
                
                .alert("Saved", isPresented: $showSaveSuccess){
                    Button("Ok",role: .cancel){}
                }
                .alert("Error", isPresented: $showSaveError){
                    Button("Ok",role: .cancel){}
                }
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage))
                }
                
                
                
                
            } //ScrollView
            //.onChange(of: packageStr){ _ in updatePrice()}
            
            //.navigationTitle("Client Details")
            
            // Enable below code to save in coredata//
            /* .sheet(isPresented: $showImagePicker) {
             ImagePicker(selectedImage: $selectedImage)
             }*/
            //}
            
        } //ZStack
            .background(Color.clear)
            .sheet(isPresented: $showMail) {
                MailView(
                    subject: "Welcome to Wow Fitness!",
                    body: "Hello \(name), your registration is completed.\nYour package starts today.",
                    recipient: savedClientEmail
                )
            }
            
    } //Body ends 
        
    func updatePrice (){
        if packageStr.lowercased() == "monthly" && type.lowercased() == "general" {
            price = "1000"
        }
        else if packageStr.lowercased() == "monthly" && type.lowercased() == "personal"
        {
            price = "3000"
            
        }
        else if packageStr.lowercased() == "quartely" && type.lowercased() == "general" {
            price = "3000"
        }
        else if packageStr.lowercased() == "quartely" && type.lowercased() == "personal"{
            price = "9000"
        }
        else if packageStr.lowercased() == "halfyearly" && type.lowercased() == "general"{
            price = "12000"
        }
        else if packageStr.lowercased() == "halfyearly" && type.lowercased() == "personal"{
            price = "18000"
        }
        else if packageStr.lowercased() == "annual" && type.lowercased() == "general"{
            price = "12000"
        }
        else if packageStr.lowercased() == "annual" && type.lowercased() == "personal"{
            price = "36000"
        }
        
    }

        
}

struct AddClient_Previews: PreviewProvider {
    static var previews: some View {
        AddClient(clientId: 00000)
    }
}
