//
//  BookDetailViewModel.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/13/23.
//

import Foundation

@MainActor
class BookDetailViewModel: ObservableObject {
    @Published var bookEntry: BookEntry
    
    init(bookEntry: BookEntry) {
        self.bookEntry = bookEntry
    }
}
