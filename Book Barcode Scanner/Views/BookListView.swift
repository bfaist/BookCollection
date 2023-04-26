//
//  ContentView.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/9/23.
//

import SwiftUI
import CodeScanner

struct BookListView: View {
    @EnvironmentObject var bookEntryManager: BookManager
    @StateObject var viewModel: BookListViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(bookEntryManager.bookEntries) { bookEntry in
                        NavigationLink(destination:
                                        BookDetailView(viewModel:
                                                        BookDetailViewModel(bookEntry: bookEntry))) {
                            AsyncImage(url: bookEntry.coverURL)
                        }
                    }.onDelete(perform: self.removeRow)
                }
            }
        }.onAppear {
            viewModel.fetchBooks()
        }.navigationTitle(viewModel.navigationTitle)
    }
    
    private func removeRow(at offsets: IndexSet) {
      for offset in offsets {
          let book = bookEntryManager.bookEntries[offset]
          bookEntryManager.delete(book)
      }
    }
}

