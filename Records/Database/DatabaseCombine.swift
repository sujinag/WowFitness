//
//  DatabaseCombine.swift
//  Wow
//
//  Created by k sujeet sudhakar nag on 04/11/25.
//

import SwiftUI
import CoreData
import Combine

//@MainActor
enum PackageType: Int, CaseIterable, Identifiable {
    case monthly = 0
    case quarterly
    case halfYearly
    case annual

    var id: Int { rawValue }
    var displayName: String {
        switch self {
        case .monthly: return "Monthly"
        case .quarterly:  return "Quarterly"
        case .halfYearly:  return "HalfYearly"
        case .annual:  return "Annual"


        }
    }
}

enum TrainingType: Int, CaseIterable, Identifiable {
    case general = 0
    case personal

    var id: Int { rawValue }
    var displayName: String {
        switch self {
        case .general:  return "General"
        case .personal: return "Personal"
        }
    }
}

enum TrainerType: Int, CaseIterable, Identifiable {
    case abdul = 0
    case harish

    var id: Int { rawValue }
    var displayName: String {
        switch self {
        case .abdul:  return "Abdul"
        case .harish: return "Harish"
        }
    }
}

enum PaymentStatus: Int, CaseIterable, Identifiable {
    case paid = 0
    case unPaid

    var id: Int { rawValue }
    var displayName: String {
        switch self {
        case .paid:  return "Paid"
        case .unPaid: return "Unpaid"
        }
    }
}



enum GenderType: Int, CaseIterable, Identifiable {
    case male = 0
    case female

    var id: Int { rawValue }
    var displayName: String {
        switch self {
        case .male:  return "Male"
        case .female: return "Female"
        }
    }
}




class DatabaseCombine: ObservableObject {
    @Published var clientDetails: [NewClient] = []
    @Published var cartCount: Int = 0  // ✅ Updates HomeView
    @Published var searchText: String = ""
    @Published var selectedFilter: TrainerFilter = .all   // NEW
    private var timerCancellable: AnyCancellable?
    
    /// PRICE UPDATE ///
    @Published var selectedPackage: PackageType = .monthly
    @Published var selectedTraining: TrainingType = .general
    @Published var selectedTrainer: TrainerType = .abdul
    @Published var selectedGender: GenderType = .male
    @Published var selectedPaymentStatus: PaymentStatus = .paid



    @Published private(set) var computedPrice: Int = 0
    
    /// PRICE UPDATE  ENDS ///
    
    private let context = DatabasePersistent.shared.context
    private var cancellables = Set<AnyCancellable>()
    @NSManaged public var photo: Data?
    
    ///
    // MARK: - Chart Arrays
    @Published var todayClients: [NewClient] = []
    @Published var monthlyClients: [NewClient] = []
    @Published var yearlyClients: [NewClient] = []
    @Published var quarterlyClients: [NewClient] = []
    @Published var sixMonthsClients: [NewClient] = []
    
    
    init() {
        setupPricePipeLine()
        fetchCartItems()
        startStatusAutoUpdateTimer()
        // ✅ Auto-update cart when Core Data changes
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: context)
            .sink { _ in self.fetchCartItems() }
            .store(in: &cancellables)
    }
    func filterClients(from start: Date, to end: Date) -> [NewClient] {
        return clientDetails.filter { client in
            guard let date = client.date else { return false }
            return date >= start && date <= end
        }
    }
    
    func calculateReports() {

        let calendar = Calendar.current
        let now = Date()

        // Today range
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        todayClients = filterClients(from: startOfDay, to: endOfDay)

        // Monthly range
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        monthlyClients = filterClients(from: startOfMonth, to: endOfMonth)

        // Yearly range
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
        
        yearlyClients = filterClients(from: startOfYear, to: endOfYear)

        // Quarterly (Last 90 days)
        let last90 = calendar.date(byAdding: .day, value: -90, to: now)!
        quarterlyClients = filterClients(from: last90, to: now)

        // Half-Year (last 180 days)
        let last180 = calendar.date(byAdding: .day, value: -180, to: now)!
        sixMonthsClients = filterClients(from: last180, to: now)
    }
    
    
    private func setupPricePipeLine() {
        Publishers
            .CombineLatest($selectedPackage,$selectedTraining)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .map{ package , training -> Int in
                switch (package,training)
            {
                case (.monthly, .general):
                    return 1000
                case (.monthly, .personal):
                    return 3000
                case (.halfYearly, .general):
                    return 4500
                case (.halfYearly, .personal):
                    return 12000
                case (.quarterly, .general):
                    return 2500
                case(.quarterly,.personal):
                    return 8000
                case(.annual,.general):
                    return 8000
                case (.annual,.personal):
                    return 22000



            }

            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                self?.computedPrice = price
            }
            .store(in: &cancellables)


           }
    

    
    enum TrainerFilter: String, CaseIterable
    {
        case all = "All"
        case abdul = "Abdul"
        case harish = "Harish"
    }
    
    var filteredTrainerClients: [NewClient] {
        var list = clientDetails
        
        // ----- Gender Filter -----
        switch selectedFilter {
        case .abdul:
            list = list.filter { ($0.trainer ?? "").lowercased() == "abdul" }
        case .harish:
            list = list.filter { ($0.trainer ?? "").lowercased() == "harish" }
        case .all:
            break
        }
        
        // ----- Search Filter -----
        if !searchText.isEmpty {
            list = list.filter {
                ($0.name ?? "").lowercased().contains(searchText.lowercased()) ||
                ($0.mobileNumber ?? "").contains(searchText)
            }
        }
        
        return list.reversed() // latest first
    }
    
    /// ✅ Fetch all cart items
    func fetchCartItems() {
        let request: NSFetchRequest<NewClient> = NewClient.fetchRequest()
        
        do {
            let items = try context.fetch(request)
            self.clientDetails = items
            self.cartCount = items.count  // ✅ Update count in HomeView
            
            
            self.calculateReports()
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
    
    var filteredClients: [NewClient] {
        if searchText.isEmpty {
            return clientDetails   // your existing array
        } else {
            return clientDetails.filter { client in
                let nameMatch = client.name?.lowercased()
                    .contains(searchText.lowercased()) ?? false
                
                let mobileMatch = client.mobileNumber?
                    .contains(searchText) ?? false
                
                let typeMatch = client.type?
                    .contains(searchText) ?? false
                
                let idMatch = String(client.clientID)
                    .contains(searchText)
                
                return nameMatch || mobileMatch || typeMatch || idMatch
            }
        }
    }
    
    /// ✅ Add item with out multi threading
    /*func addItem(itemName: String, price: String,mobNum: String) {
     
     let newItem = CartItems(context: context)
     newItem.id = UUID()
     newItem.itemName = itemName
     newItem.price = price
     newItem.mobNumber = mobNum
     
     CoreDataManager.shared.saveContext()  // ✅ Saves and auto-updates UI
     
     }*/
    
    // with  multi threading
    //photoStr: Data?,
    
    func generateRandomClientID() -> Int32 {
        return Int32(Int.random(in: 100_000...999_999))   // 6-digit
    }
    var isSuccess = false
    
    func addItem(nameSave: String, mobNumSave: String,genderSave: String,typeSave: String,photo: UIImage?,packageSave: String,trainerSave:String,photoSaveLink: String,priceSave: Int32, completion: @escaping(Bool) -> Void) {
        let backgroundContext = DatabasePersistent.shared.persistentContainer.newBackgroundContext()

        backgroundContext.perform { [self] in
            let newClient = NewClient(context: backgroundContext)  // ✅ Use correct context
            newClient.id = UUID()
            newClient.name = nameSave
            newClient.gender = genderSave
            newClient.mobileNumber = mobNumSave
           // newClient.photo = photoStr
            newClient.type = typeSave
            newClient.date = Date()
            newClient.clientID = generateRandomClientID()
            newClient.package = packageSave
            newClient.trainer = trainerSave
           // newClient.price = Int32(priceSave)
            newClient.price = Int32(computedPrice) // Enable this automatic enter price direct from UI
            newClient.photoLink = photoSaveLink
            newClient.status = selectedPaymentStatus.displayName
            newClient.statusUpdatedAt = Date()
            //GENDER DEFAULT
            let finalGender = genderSave.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Male" : genderSave
            newClient.gender = finalGender
            //TYPE DEFAULT
            let finalType = typeSave.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "General": typeSave
            newClient.type = finalType
            // PACKAGE DEFAULT
            let finalPKG = packageSave.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Monthly": packageSave
            newClient.package = finalPKG
            
            let finalTrainer = trainerSave.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Abdul": trainerSave
            newClient.trainer = finalTrainer

            let calendar = Calendar.current
            switch packageSave {
            case "Monthly":
                newClient.dueDate = calendar.date(byAdding: .weekday, value: 30, to: Date())
            case "Quarterly":
                newClient.dueDate = calendar.date(byAdding: .month, value: 3, to: Date())
            case "HalfYearly":
                newClient.dueDate = calendar.date(byAdding: .month, value: 6, to: Date())
            case "Annual":
                newClient.dueDate = calendar.date(byAdding: .year, value: 1, to: Date())
            default:
                newClient.dueDate = calendar.date(byAdding: .weekday, value: 30, to: Date())
            }
          //  let finalPKG = 
            
            if let img = photo,
                   let compressed = img.jpegData(compressionQuality: 0.8) {
                    newClient.photo = compressed
                }

            do {
                try backgroundContext.save()  // ✅ Save in the correct context
                DispatchQueue.main.async
                {
                    DatabasePersistent.shared.saveContext() // ✅ Sync to main context
                    completion(true)
                }
                print("saved Data")

               // isSuccess = true
            } catch {
                print("Failed to save: \(error.localizedDescription)")
                completion(false)

            }
        }
       // return isSuccess
    }

    /*func updateStatusForExpiredClients() { // this is for 24 hrs
        let context = DatabasePersistent.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NewClient> = NewClient.fetchRequest()

        do {
            let clients = try context.fetch(fetchRequest)
            let now = Date()

            for client in clients {
                guard let lastUpdate = client.date else { continue }

                // Check if more than 24 hours passed
                if now.timeIntervalSince(lastUpdate) >= 24 * 60 * 60 {
                    client.status = "pending"
                    client.statusUpdatedAt = now   // update timestamp
                }
            }

            try context.save()

        } catch {
            print("Failed to update statuses:", error.localizedDescription)
        }
    }*/
    
   /* func updateStatusesIfNeededForOneDay() { // it checks 1 day
        let context = DatabasePersistent.shared.persistentContainer.viewContext
        let request: NSFetchRequest<NewClient> = NewClient.fetchRequest()
        
        do {
            let clients = try context.fetch(request)
            let now = Date()
            
            for client in clients {
                if client.status == "Paid",
                   let updatedAt = client.statusUpdatedAt {
                    
                    let timeDiff = now.timeIntervalSince(updatedAt)
                    
                    if timeDiff >= 24 * 60 * 60 {   // 1 day = 86400 seconds
                        client.status = "Pending"
                    }
                }
            }
            
            try context.save()
            fetchCartItems()  // refresh UI
            
        } catch {
            print("Error updating statuses:", error.localizedDescription)
        }
    }*/
    func updateStatusesIfNeededOneMonth() { // this is for 31 days
        let context = DatabasePersistent.shared.persistentContainer.viewContext
        let request: NSFetchRequest<NewClient> = NewClient.fetchRequest()

        do {
            let clients = try context.fetch(request)
            let now = Date()

            for client in clients {
                guard client.status == "Paid" else { continue }
                guard let last = client.statusUpdatedAt else { continue }

                let diff = now.timeIntervalSince(last)
                
                // 31 Days Starts
                let days31: TimeInterval = 31 * 24 * 60 * 60
                let timePassed = now.timeIntervalSince(last)
                // 31 Days Ends here


                // 24 hours = 86400 seconds
//                if diff >= 86400 {
                if diff >= 60 { // For 1 Minute
              //  if timePassed >= days31 { // For 31 days
                    client.status = "Unpaid"
                    client.statusUpdatedAt = now
                }
            }

            try context.save()

        } catch {
            print("Error updating statuses:", error.localizedDescription)
        }
    }
    
    func updateStatusUsingDueDate() {
        let context = DatabasePersistent.shared.persistentContainer.viewContext
        let request: NSFetchRequest<NewClient> = NewClient.fetchRequest()

        do {
            let clients = try context.fetch(request)
            let today = Date()

            for client in clients {
                // Skip if already pending
                if client.status == "Paid" { continue }

                // Check due date
                if let due = client.dueDate, today >= due {
                    client.status = "Unpaid"
                }
            }

            try context.save()
        } catch {
            print("❌ Error updating statuses:", error.localizedDescription)
        }
    }
    func updateStatusesIfNeeded() {
        let context = DatabasePersistent.shared.persistentContainer.viewContext
        let request: NSFetchRequest<NewClient> = NewClient.fetchRequest()

        do {
            let clients = try context.fetch(request)
            let now = Date()
            for client in clients {
                guard let lastDate = client.statusUpdatedAt,
                      let type = client.type else { continue }

                let daysPassed = Calendar.current.dateComponents([.day], from: lastDate, to: now).day ?? 0
                print("days",daysPassed)

                var limit = 30   // default monthly

                switch type.lowercased()
                {
                case "monthly":
                    limit = 30
                case "quarterly":
                    limit = 90
                case "halfyearly":
                    limit = 183
                case "annually":
                    limit = 365
                default:
                    limit = 30
                }

                if daysPassed >= limit {
                    client.status = "pending"
                }
            }

            try context.save()

        } catch {
            print("Status update failed:", error.localizedDescription)
        }
    }
   /* func updateStatusForExpiredClients() {
        let context = DatabasePersistent.shared.context

        let request: NSFetchRequest<NewClient> = NewClient.fetchRequest()

        do {
            let allClients = try context.fetch(request)
            let now = Date()

            for client in allClients {

                guard let lastUpdate = client.statusUpdatedAt else { continue }

                let days = Calendar.current.dateComponents([.day], from: lastUpdate, to: now).day ?? 0
                 print("days",days)
                var limitDays = 31   // monthly default

                // Adjust based on type
                if client.type?.lowercased() == "quarterly" {
                    limitDays = 90
                } else if client.type?.lowercased() == "halfyearly" {
                    limitDays = 183
                }
                else if client.type?.lowercased() == "annual" {
                    limitDays = 365
                }


                // Compare
                if days >= limitDays {
                    client.status = "Pending"
                }
            }

            try context.save()

        } catch {
            print("Status update failed: \(error)")
        }
    }*/
    
    func startStatusAutoUpdateTimer() {
        timerCancellable = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
               // self?.updateStatusesIfNeeded()
                self?.updateStatusUsingDueDate()
              //  self?.updateStatusesIfNeededOneMonth() // for 1minute || day
            }
    }
   

        /// ✅ Delete item by ID With out multihtreading
        
    /*func deleteItem(byID id: UUID) {
            let request: NSFetchRequest<CartItems> = CartItems.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                if let itemToDelete = try context.fetch(request).first {
                    context.delete(itemToDelete)
                    CoreDataManager.shared.saveContext()
                }
            } catch {
                print("Failed to delete item: \(error)")
            }
        }*/
    
    
    /// ✅ Delete item by ID With   multihtreading
//    func deleteItem(byID id: UUID) {
//        let backgroundContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
//
//        backgroundContext.perform {
//            let request: NSFetchRequest<CartItems> = CartItems.fetchRequest()
//            request.predicate = NSPredicate(format: "id == %@", id as CVarArg) // ✅ Corrected predicate format
//
//            do {
//                if let itemToDelete = try backgroundContext.fetch(request).first {
//                    backgroundContext.delete(itemToDelete)
//                    try backgroundContext.save()  // ✅ Save in the correct context
//
//                    DispatchQueue.main.async {
//                        CoreDataManager.shared.saveContext() // ✅ Sync with main context
//                        self.fetchCartItems()
//                    }
//                }
//            } catch {
//                print("Failed to delete item: \(error)")
//            }
//        }
//    }
    
    func deleteItem(byID id: UUID) {
        let request: NSFetchRequest<NewClient> = NewClient.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let itemToDelete = results.first {
                print("Deleting Item: \(itemToDelete.name ?? "Unknown") with UUID: \(id)")

                context.delete(itemToDelete)
                try context.save()

                DispatchQueue.main.async
                {
                    self.fetchCartItems()  // ✅ Refresh UI immediately
                }
            } else {
                print("Item with UUID not found!")
            }
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
    //,priceUpdate:Int
    func updateItem(id: UUID, nameStr: String, mobNumStr: String,trainerSave:String,typeSave:String,packageSave: String,priceUpdate: Int32,paymentStatus: String,completion: @escaping(Bool) -> Void) {
        let request: NSFetchRequest<NewClient> = NewClient.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            if let item = try context.fetch(request).first {
                // Update fields
                item.name = nameStr
                item.mobileNumber = mobNumStr
                item.trainer = trainerSave
                item.type = typeSave
                item.package = packageSave
               // item.price = Int16(computedPrice) //// Enable this automatic enter price direct from UI
                item.price = Int32(priceUpdate)
                item.status = paymentStatus
                // Save
                let calendar = Calendar.current
                switch packageSave {
                case "Monthly":
                    item.dueDate = calendar.date(byAdding: .weekday, value: 30, to: Date())
                case "Quarterly":
                    item.dueDate = calendar.date(byAdding: .month, value: 3, to: Date())
                case "HalfYearly":
                    item.dueDate = calendar.date(byAdding: .month, value: 6, to: Date())
                case "Annual":
                    item.dueDate = calendar.date(byAdding: .year, value: 1, to: Date())
                default:
                    item.dueDate = calendar.date(byAdding: .weekday, value: 30, to: Date())
                }

                DatabasePersistent.shared.saveContext() // ✅ Sync to main context
                DispatchQueue.main.async
                {
                    self.fetchCartItems()  // ✅ Refresh UI immediately
                }
                print("✅ Updated successfully by UUID")
                completion(true)
            } else {
                print("❌ No item found with this UUID")
            }
        } catch {
            print("❌ Update failed: \(error.localizedDescription)")
            completion(false)

        }
    }

    
   /* @Published var cartItems: [CartItems] = []  // Stores cart data
    @Published var cartCount: Int = 0  // ✅ Updates HomeView

    private var context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    // Inject Core Data context from CoreDataManager
    init(context: NSManagedObjectContext = CoreDataManager.shared.context)
    {
        self.context = context
        fetchCartItems()  // Load items initially
    }

    // Fetch all cart items from Core Data
    func fetchCartItems()
    {
        let request: NSFetchRequest<CartItems> = CartItems.fetchRequest()
        do {
            cartItems = try context.fetch(request)
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    func fetchItemByName(_ name: String)
    {
        let request: NSFetchRequest<CartItems> = CartItems.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)  // WHERE name = 'iPhone'

        do {
            cartItems = try context.fetch(request)  // ✅ Updates UI
        } catch {
            print("Failed to fetch item by name: \(error)")
        }
    }

    /*/// ✅ Fetch only items where price > 100 (like `WHERE price > 100`)
        func fetchExpensiveItems() {
            let request: NSFetchRequest<Sujeet> = Sujeet.fetchRequest()
            request.predicate = NSPredicate(format: "price > %f", 100)  // `WHERE price > 100`
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]  // ORDER BY name ASC

            do {
                cartItems = try context.fetch(request)  // ✅ Updates UI
            } catch {
                print("Failed to fetch expensive items: \(error)")
            }
        }*/
    func deleteItem(byID id: UUID) {
        let request: NSFetchRequest<CartItems> = CartItems.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)  // UUID comparison

        do {
            if let itemToDelete = try context.fetch(request).first {  // Only one match
                context.delete(itemToDelete)
                saveChanges()
            } else {
                print("Item with ID \(id) not found")
            }
        } catch {
            print("Failed to delete item: \(error)")
        }
    }

    // Add a new item to the cart
    func addItem(itemName: String, price: String,mobNum: String) {
        let newItem = CartItems(context: context)
        newItem.id = UUID()
        newItem.itemName = itemName
        newItem.price = price
        newItem.mobNumber = mobNum
        saveChanges()
    }

    // Remove an item from the cart
    func removeItem(item: CartItems) {
        context.delete(item)
        saveChanges()
    }

    // Save data changes to Core Data
    private func saveChanges() {
        do {
            try context.save()
            print("saved")

            fetchCartItems()  // Refresh UI
        } catch {
            print("Failed to save: \(error)")
        }
    }*/
    
    
    func isValidName(_ name: String) -> Bool {
        let regex = "^[A-Za-z ]{3,30}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: name)
    }

    func isValidMobile(_ number: String) -> Bool {
        let regex = "^[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: number)
    }

    func isValidPrice(_ price: String) -> Bool {
        let regex = "^[0-9]{1,6}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: price)
    }

    func isValidGender(_ gender: String) -> Bool {
        return ["Male","Female","Other"].contains(gender)
    }
    func isValidImageUrl(_ imageUrl: String) -> Bool
    {
        let imagePattern = #"\bhttps?://\S+\.(jpe?g|bmp|png|gif)\b"#
        return NSPredicate(format: "SELF MATCHES %@", imagePattern).evaluate(with: imageUrl)

    }
    
}

