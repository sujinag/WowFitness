//
//  MyClients.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 25/11/25.
//

import SwiftUI

struct MyClients: View {
//    init() {
//            UITableView.appearance().backgroundColor = .clear
//        }

        
        @StateObject var viewModel = DatabaseCombine()
   // @EnvironmentObject var viewModel: DatabaseCombine  // ✅ Access shared ViewModel
    let fixedScreenBounds = UIScreen.main.fixedCoordinateSpace.bounds

        var body: some View {
            ZStack{
                BackGround()
                
                
                VStack {
                    
                    // ---- SEARCH BAR ----
                    TextField("Search…", text: $viewModel.searchText)
                        .padding(10)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                       // .shadow(color: Color.black, radius: 0.2, y: 0.2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black.opacity(0.5))
                        )

                        .padding(.horizontal)
                    
                    // ---- SEGMENTED CONTROL ----
                    Picker("Filter", selection: $viewModel.selectedFilter) {
                        ForEach(DatabaseCombine.TrainerFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)
                    
                    // ---- LIST ----
                    List {
                        ForEach(Array(viewModel.filteredTrainerClients.enumerated()), id: \.element.id) { index, client in
                            
                            HStack {
                                Text("\(index + 1).")        // index number
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(client.name ?? "No Name")
                                        .listRowBackground(Color.clear)
                                    //.font(.headline)
                                        .font(.custom("times-bold", size: fixedScreenBounds.width / 20))
                                    
                                    
                                    //                                Text(client.gender ?? "")
                                    //                                    .font(.subheadline)
                                    Text(client.status ?? "")
                                        .font(.subheadline)
                                    Text("DueDate:\(dateToString(date: client.dueDate ?? Date()))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    HStack
                                    {
                                        Text("Mobile:")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Button(action: {
                                            let phoneNumberformatted = client.mobileNumber ?? ""
                                            guard let url = URL(string: phoneNumberformatted) else { return }
                                            UIApplication.shared.open(url)
                                            print(url)
                                        }) {
                                            Text(client.mobileNumber ?? "")
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                        }
                                        
                                    }
                                    
                                    
                                    
                                }
                            } //H
                            .listRowBackground(Color.white.opacity(0.85))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)


                        }

                    }// LIST
                    .listStyle(.plain)
//                    .background(.clear.opacity(0.8))
//                   // .shadow(color: Color.black, radius: 0.2, y: 0.2)
                    .padding(.horizontal)

                } //VStack

            }
            .background(.black.opacity(0.8))

        }
    
    } //MyCleintsView

struct MyClients_Previews: PreviewProvider {
    static var previews: some View {
        MyClients()
    }
}
