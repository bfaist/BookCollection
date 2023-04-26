//
//  BookListViewModelTests.swift
//  Book Barcode ScannerTests
//
//  Created by Robert Faist on 4/25/23.
//

import XCTest
@testable import Book_Barcode_Scanner

final class BookListViewModelTests: XCTestCase {
    
    let context = PersistenceController(inMemory: true).container.viewContext
    
    func test_navigationTitle() {
        let bookManager = BookManager(context: context)
        
        let bookCategory = BookCategory(context: context)
        bookCategory.name = "Test Category"

        try? context.save()
        
        let sut = BookListViewModel(bookCategory: bookCategory, bookManager: bookManager)
            
        XCTAssertEqual("Test Category", sut.navigationTitle)
    }
    
    func test_fetchBooksByCategory() {
        let bookManager = BookManager(context: context)
        
        let bookCategory = BookCategory(context: context)
        bookCategory.name = "Fiction"
        
        let bookEntry1 = BookEntry(context: context)
        bookEntry1.title = "Fiction Title 1"
        
        let bookEntry2 = BookEntry(context: context)
        bookEntry1.title = "Fiction Title 2"
        
        bookCategory.addToBookEntries(bookEntry1)
        bookCategory.addToBookEntries(bookEntry2)
        
        try? context.save()
        
        let sut = BookListViewModel(bookCategory: bookCategory, bookManager: bookManager)
        
        sut.fetchBooks()
        
        XCTAssertEqual(2, sut.bookCategory.bookEntries?.count)
    }
}
