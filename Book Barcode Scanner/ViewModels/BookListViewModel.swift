//
//  BookListViewModel.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/9/23.
//

import Foundation

class BookListViewModel: ObservableObject {
    var bookCategory: BookCategory
    
    var navigationTitle: String {
        bookCategory.name
    }
    
    private let bookManager: BookManager
    
    init(bookCategory: BookCategory, bookManager: BookManager) {
        self.bookCategory = bookCategory
        self.bookManager = bookManager
    }
    
    func fetchBooks() {
        bookManager.loadBooks(bookCategory: bookCategory)
    }
}
