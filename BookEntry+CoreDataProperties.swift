//
//  BookEntry+CoreDataProperties.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/24/23.
//
//

import Foundation
import CoreData

extension BookEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntry> {
        return NSFetchRequest<BookEntry>(entityName: "BookEntry")
    }

    @NSManaged public var title: String
    @NSManaged public var subtitle: String?
    @NSManaged public var bookDescription: String
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var publisherName: String?
    @NSManaged public var publishedDate: Date?
    @NSManaged public var authors: String
    @NSManaged public var pageCount: Int16
    @NSManaged public var averageRating: NSNumber?
    @NSManaged public var ratingsCount: Int16
    @NSManaged public var isbn10barcode: String?
    @NSManaged public var isbn13barcode: String?
    @NSManaged public var id: UUID
    @NSManaged public var category: BookCategory
}

extension BookEntry : Identifiable {
    var coverURL: URL? {
        guard let url = thumbnailURL?.http2https() else { return nil }
        return URL(string: url)
    }
    
    var publishedDateString: String? {
        guard let pubDate = publishedDate else { return nil }
        return Date.publishDateString(from: pubDate)
    }
}
