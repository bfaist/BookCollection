//
//  BookView.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/10/23.
//

import SwiftUI

struct BookListItemView: View {
    let book: BookEntry
    
    var body: some View {
        HStack {
            if let coverURL = book.coverURL {
                AsyncImage(url: coverURL).imageScale(.small)
            }
            VStack(alignment: .leading) {
                Text(book.title).font(Font.title)
                Spacer()
                Text(book.authors)
                Spacer()
                if let pubDate = book.publishedDateString {
                    Text(pubDate)
                }
            }
        }
    }
}
