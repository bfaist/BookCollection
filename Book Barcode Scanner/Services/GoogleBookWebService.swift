//
//  GoogleBookWebService.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/9/23.
//

import Foundation

public enum BookAPIError: Error {
    case invalidURL
    case decodeError
    case notFound
    case serverError
}

public protocol GoogleBookWebService {
    func getBook(isbn: String) async throws -> BookEntry
}

class GoogleBookWebServiceImpl: GoogleBookWebService {
    private struct config {
        static let url = "https://www.googleapis.com/books/v1/volumes"
    }
    
    func getBook(isbn: String) async throws -> BookEntry {
        guard let url = URL(string: config.url) else {
            throw BookAPIError.invalidURL
        }
        
        var copyUrl = url
        copyUrl.append(queryItems: [URLQueryItem(name: "q", value: "isbn:\(isbn)")])
        
        let urlRequest = URLRequest(url: copyUrl)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw BookAPIError.serverError
        }
        
        guard let codingUserKeyContext = CodingUserInfoKey(rawValue: "managedObjectContext") else {
            throw BookAPIError.decodeError
        }
        
        do {
            let decoder = JSONDecoder()
            let context = PersistenceController.shared.container.viewContext
            decoder.userInfo[codingUserKeyContext] = context
            let bookEntry = try decoder.decode(BookEntry.self, from: data)
            return bookEntry
        } catch let decodeError as DecodingError {
            print("Decode Error \(decodeError)")
            throw BookAPIError.decodeError
        } catch {
            throw BookAPIError.serverError
        }
    }
}
