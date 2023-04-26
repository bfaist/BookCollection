//
//  ScannedBookViewModelTests.swift
//  Book Barcode ScannerTests
//
//  Created by Robert Faist on 4/25/23.
//

import XCTest
@testable import Book_Barcode_Scanner

final class ScannedBookViewModelTests: XCTestCase {
    
    let context = PersistenceController(inMemory: true).container.viewContext
    
    var bookManager: BookManager {
        BookManager(context: context)
    }

    func test_buttonLabel() {
        let sut = ScannedBookViewModel(webService: MockGoogleBookWebService(), isbn: "12345657890", bookManager: bookManager)
        
        XCTAssertEqual("Save to collection", sut.saveButtonLabel)
    }
}
