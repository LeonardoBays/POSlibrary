//
//  poslibraryApp.swift
//  poslibrary
//
//  Created by user280070 on 1/3/26.
//

import SwiftUI

@main
struct poslibraryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
