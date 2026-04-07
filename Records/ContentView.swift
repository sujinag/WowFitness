//
//  ContentView.swift
//  Records
//
//  Created by k sujeet sudhakar nag on 11/09/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showPopup = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @EnvironmentObject var cartViewModel: DatabaseCombine

    var body: some View {
        TabView
        {
            AddClient(clientId: 00000)
            //AddNewClient(isPresented: .constant(true))
                .tabItem
            {
                Label("Home", systemImage: "house")
                // .toolbar(.visible, for: .automatic)
            //.toolbarBackground(Color.blue, for: .tabBar) // Set the background color

            }
            Clients()
                .tabItem
            {
                Label("Clients", systemImage: "person.fill")
                // .toolbar(.visible, for: .automatic)
            }
            
            MyClients()
                .tabItem
            {
                Label("MyClients", systemImage: "person.fill")
                // .toolbar(.visible, for: .automatic)
            }

            
            ReportsView()
                .tabItem
            {
                Label("Reports", systemImage: "pencil.line")
                // .toolbar(.visible, for: .automatic)
            }

           
        }
        //.tint(.)
        


       // New()
       // AddNewClient(isPresented: .constant(true))
        /* NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    EditButton()
                }
                ToolbarItem {
//                    Button(action: addItem)
//                    {
//                        Label("Add Item", systemImage: "plus")
//                    }
                    Button(action: {
                                    showPopup = true
                                }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                }
                }
            }
            Text("Select an item")
        }
        
        .sheet(isPresented: $showPopup) {
                    VStack {
                        Text("This is a popup sheet!")
                            .font(.title)
                            .padding()

                        Button("Close") {
                            showPopup = false
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                } */
        
    } //body View

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      //  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        ContentView().environmentObject(DatabaseCombine())

    }
}
