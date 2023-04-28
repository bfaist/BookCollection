//
//  MockGoogleBookWebService.swift
//  Book Barcode ScannerTests
//
//  Created by Robert Faist on 4/25/23.
//

import Foundation
import Book_Barcode_Scanner

class MockGoogleBookWebService: GoogleBookWebService {
    var testISBN: String = ""
    var hasError: Bool = false
    var apiError: BookAPIError = .decodeError
    
    private let mockJSONFile = "MockGoogleBookResponse"
    
    func getBook(isbn: String) async throws -> Book_Barcode_Scanner.BookEntry {
        guard !hasError else {
            throw apiError
        }
        
        let bundle = Bundle(for: type(of: self))
        
        guard let jsonURL = bundle.url(forResource: mockJSONFile, withExtension: "json") else {
            throw BookAPIError.invalidURL
        }
        
        guard let jsonDATA = try? Data(contentsOf: jsonURL) else {
            throw BookAPIError.serverError
        }
        
        guard let codingUserKeyContext = CodingUserInfoKey(rawValue: "managedObjectContext") else {
            throw BookAPIError.decodeError
        }
        
        do {
            let decoder = JSONDecoder()
            let context = PersistenceController.shared.container.viewContext
            decoder.userInfo[codingUserKeyContext] = context
            let bookEntry = try decoder.decode(BookEntry.self, from: jsonDATA)
            return bookEntry
        } catch let decodeError as DecodingError {
            print("Decode Error \(decodeError)")
            throw BookAPIError.decodeError
        } catch {
            throw BookAPIError.serverError
        }
    }
}
