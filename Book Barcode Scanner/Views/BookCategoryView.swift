//
//  BookCategoryView.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 4/5/23.
//

import SwiftUI

struct BookCategoryView: View {
    @EnvironmentObject var bookManager: BookManager
    var bookCategory: BookCategory
    
    var body: some View {
        Text(bookCategory.name)
    }
}

