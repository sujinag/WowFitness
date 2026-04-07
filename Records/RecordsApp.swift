//
//  RecordsApp.swift
//  Records
//
//  Created by k sujeet sudhakar nag on 11/09/25.
//

import SwiftUI

@main
struct RecordsApp: App {
    let persistenceController = DatabasePersistent.shared
    @StateObject var clientDetailsViewModel = DatabaseCombine()  // ✅ Shared ViewModel
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        // ✅ background color with opacity
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        //appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)


        UITabBar.appearance().tintColor = UIColor.systemBlue
       // UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray
        //UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.35)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance


    }
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
                .environmentObject(clientDetailsViewModel)        }
    }
}
