//
//  Book_Barcode_ScannerApp.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/9/23.
//

import SwiftUI
import CoreData

@main
struct Book_Barcode_ScannerApp: App {
    let persistenceController = PersistenceController.shared
    var bookManager: BookManager {
        BookManager(context: persistenceController.container.viewContext)
    }
    
    var body: some Scene {
        WindowGroup {
            BookCategoryListView(viewModel: BookCategoryListViewModel())
                .environmentObject(bookManager)
        }
    }
}
