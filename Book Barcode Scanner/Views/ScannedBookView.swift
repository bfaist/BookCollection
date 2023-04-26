//
//  ScannedBookView.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/27/23.
//

import SwiftUI

struct ScannedBookView: View {
    @StateObject var viewModel: ScannedBookViewModel
    @State var showFindBookError = false
    @State var findBookError: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if let bookDetail = viewModel.bookEntry {
                    Text(bookDetail.title).font(Font.title).padding()
                    Text(bookDetail.authors).padding()
                    AsyncImage(url: bookDetail.coverURL).padding()
                    Text(bookDetail.bookDescription).padding()
                    HStack {
                        Text(bookDetail.publisherName ?? "")
                        Text(bookDetail.publishedDateString ?? "")
                    }
                    saveButton
                }
            }.onAppear {
                Task {
                    do {
                        try await viewModel.findBookDetails()
                    } catch {
                        showFindBookError = true
                        findBookError = error.localizedDescription
                    }
                }
            }.alert(isPresented: $showFindBookError) {
                Alert(title: Text("Error"), message: Text(findBookError ?? ""), dismissButton: .cancel() {
                    showFindBookError = false
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
    
    var saveButton: some View {
        Button {
            viewModel.saveBookItem()
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text(viewModel.saveButtonLabel)
        }.padding()
            .buttonStyle(.bordered)
    }
}

