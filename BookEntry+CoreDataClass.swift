//
//  BookEntry+CoreDataClass.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/24/23.
//
//

import Foundation
import CoreData

@objc(BookEntry)
public class BookEntry: NSManagedObject, Decodable {
    struct Item: Decodable {
        let volumeInfo: VolumeInfo
    }
    
    struct VolumeInfo: Decodable {
        let title: String
        let subtitle: String?
        let authors: [String]
        let publisher: String
        let publishedDate: String
        let description: String
        let pageCount: Int
        let imageLinks: ImageLinks?
        let averageRating: Double?
        let categories: [String]?
        let industryIdentifiers: [IndustryIdentifiers]
    }
    
    struct ImageLinks: Decodable {
        let smallThumbnail: String
        let thumbnail: String
    }
    
    struct IndustryIdentifiers: Decodable {
        enum IdentifierType: String, Decodable {
            case isbn10 = "ISBN_10"
            case isbn13 = "ISBN_13"
        }
        
        let type: IdentifierType
        let identifier: String
    }
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let userInfoContext = CodingUserInfoKey(rawValue: "managedObjectContext"),
              let context = decoder.userInfo[userInfoContext] as? NSManagedObjectContext else {
            fatalError()
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let items = try container.decode([Item].self, forKey: .items)
        
        guard let firstItem = items.first else {
            fatalError()
        }
        
        self.id = UUID()
        self.title = firstItem.volumeInfo.title
        self.authors = String(firstItem.volumeInfo.authors.joined(separator: ", "))
        self.publisherName = firstItem.volumeInfo.publisher
        self.publishedDate = Date.publishDate(from: firstItem.volumeInfo.publishedDate)
        
        self.bookDescription = firstItem.volumeInfo.description
        self.thumbnailURL = firstItem.volumeInfo.imageLinks?.smallThumbnail.http2https()
        self.pageCount = Int16(firstItem.volumeInfo.pageCount)
        self.averageRating = NSNumber(value: firstItem.volumeInfo.averageRating ?? 0.0)
        
        self.isbn10barcode = firstItem.volumeInfo.industryIdentifiers.filter({ $0.type == IndustryIdentifiers.IdentifierType.isbn10 }).first?.identifier
        self.isbn13barcode = firstItem.volumeInfo.industryIdentifiers.filter({ $0.type == IndustryIdentifiers.IdentifierType.isbn13 }).first?.identifier
        
        let bookManager = BookManager(context: context)
        
        let categories = firstItem.volumeInfo.categories ?? ["Unknown"]
        
        categories.forEach({ categoryName in
            let newCategoryName = categoryName.lowercased().capitalized
            
            if bookManager.doesThisBookCategoryExist(name: newCategoryName) {
                let bookCategory = bookManager.fetchBookCategory(by: newCategoryName)
                bookCategory?.addToBookEntries(self)
            } else {
                let bookCategory = BookCategory(context: context)
                bookCategory.id = UUID()
                bookCategory.name = newCategoryName
                bookCategory.addToBookEntries(self)
                context.insert(bookCategory)
            }
        })
    }
}
