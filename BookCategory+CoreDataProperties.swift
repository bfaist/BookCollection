//
//  BookCategory+CoreDataProperties.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 4/5/23.
//
//

import Foundation
import CoreData


extension BookCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCategory> {
        return NSFetchRequest<BookCategory>(entityName: "BookCategory")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var bookEntries: NSSet?

}

// MARK: Generated accessors for bookEntries
extension BookCategory {

    @objc(addBookEntriesObject:)
    @NSManaged public func addToBookEntries(_ value: BookEntry)

    @objc(removeBookEntriesObject:)
    @NSManaged public func removeFromBookEntries(_ value: BookEntry)

    @objc(addBookEntries:)
    @NSManaged public func addToBookEntries(_ values: NSSet)

    @objc(removeBookEntries:)
    @NSManaged public func removeFromBookEntries(_ values: NSSet)

}

extension BookCategory : Identifiable {

}
