//
//  ScannedBookViewModelTests.swift
//  Book Barcode ScannerTests
//
//  Created by Robert Faist on 4/25/23.
//

import XCTest
import CoreData
@testable import Book_Barcode_Scanner

final class ScannedBookViewModelTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var bookManager: BookManager!
    
    override func setUp() async throws {
        context = PersistenceController(inMemory: true).container.viewContext
        bookManager = BookManager(context: context)
    }

    func test_buttonLabel() {
        let sut = ScannedBookViewModel(webService: MockGoogleBookWebService(), isbn: "12345657890", bookManager: bookManager)
        
        XCTAssertEqual("Save to collection", sut.saveButtonLabel)
    }
    
    func test_getBookDetails() async {
        let sut = ScannedBookViewModel(webService: MockGoogleBookWebService(), isbn: "12345657890", bookManager: bookManager)

        do {
            try await sut.findBookDetails()
        } catch {
            XCTFail(error.localizedDescription)
        }

        XCTAssertEqual("The Name of the Wind", sut.bookEntry?.title)
        XCTAssertEqual("Penguin", sut.bookEntry?.publisherName)
        XCTAssertEqual(674, sut.bookEntry?.pageCount)
    }
    
    func test_saveBook() async {
        let sut = ScannedBookViewModel(webService: MockGoogleBookWebService(), isbn: "12345657890", bookManager: bookManager)
        
        do {
            try await sut.findBookDetails()
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        sut.saveBookItem()
        
        XCTAssertEqual("The Name of the Wind", bookManager.newBookEntry?.title)
        XCTAssertEqual("Penguin", bookManager.newBookEntry?.publisherName)
        XCTAssertEqual(674, bookManager.newBookEntry?.pageCount)
    }
}
