//
//  BookEntryManager.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/22/23.
//

import Foundation
import CoreData

class BookManager: ObservableObject {
    @Published var bookEntries: [BookEntry] = []
    @Published var bookCategories: [BookCategory] = []
    
    var newBookEntry: BookEntry? {
        didSet {
            if let _ = newBookEntry {
                save()
            }
        }
    }
    
    private var _context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self._context = context
        
        loadCategories()
    }
    
    private func loadCategories() {
        let request: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(BookCategory.name), ascending: true)]
        
        do {
            bookCategories = try _context.fetch(request)
        } catch {
            print("Category load error \(error.localizedDescription)")
        }
    }
    
    func loadBooks(bookCategory: BookCategory) {
        if let books = bookCategory.bookEntries?.allObjects as? [BookEntry] {
            bookEntries = books
        }
    }
    
    func doesThisBookEntryExist(isbn: String) -> Bool {
        let request: NSFetchRequest<BookEntry> = BookEntry.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(BookEntry.isbn13barcode), isbn)
        
        do {
            let bookCount = try _context.fetch(request).count
            return bookCount > 0
        } catch {
            return false
        }
    }
    
    func doesThisBookCategoryExist(name: String) -> Bool {
        let request: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(BookCategory.name), name)
        
        do {
            let categoryCount = try _context.fetch(request).count
            return categoryCount > 0
        } catch {
            return false
        }
    }
    
    func fetchBookCategory(by name: String) -> BookCategory? {
        let request: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(BookCategory.name), name)
        
        do {
            let category = try _context.fetch(request)
            return category.first
        } catch {
            print("Failed to find book category : \(name)")
        }
        
        return nil
    }
    
    private func save() {
      do {
        if _context.hasChanges {
            try _context.save()
        }
      }
      catch {
        print(error.localizedDescription)
        _context.rollback()
      }
      
      loadCategories()
    }
    
    func delete(_ bookEntry: BookEntry) {
      _context.performAndWait {
        _context.delete(bookEntry)
        save()
      }
      
      loadCategories()
    }
}
