//
//  BookCategoryListViewModel.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 4/5/23.
//

import Foundation

class BookCategoryListViewModel: ObservableObject {
    @Published var scannedBarcode: String?
    
    let navigationTitle = "Book Collection"
    
    func scannedBook(isbn: String) {
        scannedBarcode = isbn
    }
}
