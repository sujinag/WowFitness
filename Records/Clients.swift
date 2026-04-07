//
//  Clients.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 14/11/25.
//

import SwiftUI
import CoreData
struct Clients: View {
    @EnvironmentObject var viewModel: DatabaseCombine  // ✅ Access shared ViewModel
    let fixedScreenBounds = UIScreen.main.fixedCoordinateSpace.bounds
    var body: some View {
        
        NavigationView{
            ZStack {
                BackGround()
            
            VStack {
                TextField("Search…", text: $viewModel.searchText)
                    .padding(10)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
                    .background(.white.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                   // .shadow(color: Color.black, radius: 0.2, y: 0.2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.4))
                    )

                    .padding(.horizontal)

                // SearchBar(text: $viewModel.searchText)
                List {
                    //                    let filterTrainers = viewModel.filteredClients.filter { ($0.trainer ?? "").lowercased() == "abdul" }
                    //
                    //                    ForEach(Array(filterTrainers.enumerated()),id: \.element.id ){index,data in
                    
                    ForEach(viewModel.filteredClients.reversed().enumerated().map({ $0 }), id: \.element.id){ index,data in
                        NavigationLink {
                            VStack {
                                // Convert Data? → UIImage with safe fallback
                                let image: UIImage = {
                                    if let photoData = data.photo,
                                       let uiImage = UIImage(data: photoData) {
                                        return uiImage
                                    } else {
                                        return UIImage(named: "placeholder") ?? UIImage()   // fallback
                                    }
                                }()
                                // Now you can use `image`
                                // Now you can use `image`
                                
                                ClientDetailsView(name: data.name ?? "", gender: data.gender ?? "", mobileNumber: data.mobileNumber ?? "XXXXXX", type: data.type ?? "", joiningDate: dateToString(date: data.date ?? Date()),idStr: data.id ?? UUID(),trainer: data.trainer ?? "", savedImage: image, photoUrl: data.photoLink ?? "",  amountPaid:(data.price),package: data.package ?? "", dueDate: dateToString(date: data.dueDate ?? Date()), status: data.status ?? "")
                                    .background(.clear.opacity(0.8))

                                
                            } //VStack
                            .background(.clear.opacity(0.8))

                            
                        }  label: {
                            HStack {
                                VStack {
                                    Text("\(index + 1). \(data.name ?? "Unknown")")
                                        .font(.custom("times-bold", size: fixedScreenBounds.width / 20))
                                    //Text(data.id?.description ?? "NoData")
                                }
                                Spacer()
                            }
                            .listRowBackground(Color.white.opacity(0.85))

                            
                            
                        }

                        
                        .swipeActions {
                            Button(role: .destructive) {
                                if let itemID = data.id {
                                    viewModel.deleteItem(byID: itemID) // ✅ Pass UUID directly
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    //                .onDelete(perform: deleteItem)
                    
                } //List
                .listStyle(.plain)
//                    .background(.clear.opacity(0.8))
//                   // .shadow(color: Color.black, radius: 0.2, y: 0.2)
                .padding(.horizontal)


                
            } //VStack
            
            
            //   .navigationTitle("Clients")
            .onAppear{
                viewModel.fetchCartItems()
            }
            
            
        } //nav Stack
       // .background(.red)
        
      //  .searchable(text: $viewModel.searchText,prompt: "Search by name, mobile or ID")

        
    }
    }
//    private func deleteItem(byUUID id: UUID) {
//        print("Deleting item with ID: \(id)")
//        viewModel.deleteItem(byID: id) // ✅ Calls Core Data function to delete
//        DispatchQueue.main.async {
//            viewModel.fetchCartItems() // ✅ Reload UI after deletion
//        }
//    }
    
    

    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = viewModel.clientDetails[index]  // ✅ Get item
            if let itemID = item.id {             // ✅ Extract UUID
                print("Deleting item with UUID: \(itemID)")
                viewModel.deleteItem(byID: itemID) // ✅ Delete by UUID
            }
        }
    }


    /// ✅ Deletes item when swiped
        private func deleteItemBySwipe(at offsets: IndexSet) {
            for index in offsets {
                let item = viewModel.clientDetails[index]
                if let itemID = item.id {
                    print(itemID)
                    viewModel.deleteItem(byID: itemID)  // ✅ Deletes from Core Data
                    DispatchQueue.main.async
                    {
                        self.viewModel.clientDetails.remove(at: index) // ✅ Remove from UI manually
                        
                    }
                }
            }

            
        } //Delete by Swipe
    }

func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    // Set a specific format
//    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    dateFormatter.dateFormat = "MMM d, yyyy"

    // Set the locale for consistent formatting, especially for fixed formats
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.string(from: date)
}
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search by name, mobile, ID", text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
struct Clients_Previews: PreviewProvider {
    static var previews: some View {
        Clients()
            .environmentObject(DatabaseCombine())

    }
}
