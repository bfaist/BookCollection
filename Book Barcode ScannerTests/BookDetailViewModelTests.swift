//
//  BookDetailViewModelTests.swift
//  Book Barcode ScannerTests
//
//  Created by Robert Faist on 4/25/23.
//

import XCTest
@testable import Book_Barcode_Scanner

final class BookDetailViewModelTests: XCTestCase {
    
    let context = PersistenceController(inMemory: true).container.viewContext

    func test_bookEntry() {
        let bookEntry = BookEntry(context: context)
        
        bookEntry.title = "Test Title"
        
        let sut = BookDetailViewModel(bookEntry: bookEntry)
        
        XCTAssertEqual("Test Title", sut.bookEntry.title)
    }
}
