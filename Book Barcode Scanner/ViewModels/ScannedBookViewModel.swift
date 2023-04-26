//
//  ScannedBookViewModel.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/27/23.
//

import Foundation

enum ScanBookError: Error, LocalizedError {
    case duplicateBook
    
    var errorDescription: String? {
        switch self {
        case .duplicateBook:
            return "Book already exists in your collection."
        }
    }
}

class ScannedBookViewModel: ObservableObject {
    @Published var bookEntry: BookEntry?
    
    private let webService: GoogleBookWebService
    private let isbn: String
    private let bookManager: BookManager
    
    init(webService: GoogleBookWebService, isbn: String, bookManager: BookManager) {
        self.webService = webService
        self.isbn = isbn
        self.bookManager = bookManager
    }
    
    var saveButtonLabel = "Save to collection"
    
    @MainActor
    func findBookDetails() async throws {
        guard !bookManager.doesThisBookEntryExist(isbn: isbn) else {
            throw ScanBookError.duplicateBook
        }
        bookEntry = try await webService.getBook(isbn: isbn)
    }
    
    func saveBookItem() {
        guard let bookEntry = bookEntry else { return }
        bookManager.newBookEntry = bookEntry
    }
}
