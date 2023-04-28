//
//  BookCategoryListViewModelTests.swift
//  Book Barcode ScannerTests
//
//  Created by Robert Faist on 4/25/23.
//

import XCTest
@testable import Book_Barcode_Scanner

final class BookCategoryListViewModelTests: XCTestCase {

    func test_title() {
        let sut = BookCategoryListViewModel()
        
        XCTAssertEqual("Book Collection", sut.navigationTitle)
    }
    
    func test_scanned_barcode() {
        let sut = BookCategoryListViewModel()
        
        sut.scannedBook(isbn: "1234567890")
        
        XCTAssertEqual("1234567890", sut.scannedBarcode)
    }
}
