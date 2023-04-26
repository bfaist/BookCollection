//
//  BookDetailView.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/12/23.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if let bookEntry = viewModel.bookEntry {
                    Text(bookEntry.title).font(Font.title).padding()
                    Text(bookEntry.authors).padding()
                    AsyncImage(url: bookEntry.coverURL).padding()
                    Text(bookEntry.bookDescription).padding()
                    if bookEntry.pageCount > 0 {
                        Text("Page Count: \(bookEntry.pageCount)").padding()
                    }
                    publisherView
                }
            }
        }
    }
    
    private var publisherView: some View {
        HStack {
            if let publisherName = viewModel.bookEntry.publisherName {
                Text(publisherName)
            }
            if let publishedDate = viewModel.bookEntry.publishedDateString {
                Text(publishedDate)
            }
        }.padding()
    }
}

