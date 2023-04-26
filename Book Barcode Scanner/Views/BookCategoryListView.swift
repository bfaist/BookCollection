//
//  BookCategoryListView.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 4/5/23.
//

import SwiftUI
import CodeScanner

struct BookCategoryListView: View {
    @StateObject var viewModel: BookCategoryListViewModel
    @EnvironmentObject var bookManager: BookManager
    @State var isScannerPresented = false
    @State var showScanError = false
    @State var scanErrorMessage: String?
    @State var showLookupError = false
    @State var lookupErrorMessage: String?
    @State var showScannedBookDetail = false
    @State var scannedISBNNumber: String = ""
    
    var body: some View {
        VStack {
            bookCategoryListView
        }.alert(isPresented: $showScanError) {
            scanErrorAlert
        }.alert(isPresented: $showLookupError) {
            lookupErrorAlert
        }.sheet(isPresented: $isScannerPresented) {
            scannerView
        }.sheet(isPresented: $showScannedBookDetail, onDismiss: { showScannedBookDetail = false }) {
            if let scannedISBN = viewModel.scannedBarcode {
                ScannedBookView(viewModel: ScannedBookViewModel(webService: GoogleBookWebServiceImpl(),
                                                                isbn: scannedISBN,
                                                                bookManager: bookManager))
            }
        }
    }
    
    var bookCategoryListView: some View {
        NavigationView {
            List {
                ForEach(bookManager.bookCategories) { bookCategory in
                    NavigationLink(destination: BookListView(viewModel: BookListViewModel(bookCategory: bookCategory, bookManager: bookManager))) {
                        BookCategoryView(bookCategory: bookCategory)
                    }
                }
            }.navigationTitle(viewModel.navigationTitle)
             .toolbar { toolbarAddButton }
        }
    }
    
    @ToolbarContentBuilder
    var toolbarAddButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isScannerPresented = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    var lookupErrorAlert: Alert {
        Alert(title: Text("Error"),
              message: Text("Lookup Error: \(lookupErrorMessage ?? "")"),
              dismissButton: .cancel({
            showLookupError = false
        }))
    }
    
    var scanErrorAlert: Alert {
        Alert(title: Text("Scan Error"),
              message: Text("Scan Error: \(scanErrorMessage ?? "")"),
              dismissButton: .cancel({
            showScanError = false
        }))
    }
    
    var scannerView: some View {
        #if targetEnvironment(simulator)
        VStack {
            TextField("Enter ISBN Number", text: $scannedISBNNumber)
                .padding()
                .textFieldStyle(.roundedBorder)
            Button {
                viewModel.scannedBook(isbn: scannedISBNNumber)
                isScannerPresented = false
                showScannedBookDetail = true
            } label: {
                Text("Find Book")
            }.buttonStyle(.bordered)
        }.presentationDetents([.medium])
        #else
        CodeScannerView(codeTypes: [.ean13]) { result in
            switch result {
            case .success(let scanResult):
                scannedISBNNumber = scanResult.string
                if let isbnNumber = scannedISBNNumber {
                    viewModel.scannedBook(isbn: isbnNumber)
                }
                showScannedBookDetail = true
            case .failure(let error):
                scanErrorMessage = error.localizedDescription
                showScanError = true
            }
            
            isScannerPresented = false
        }
        #endif
    }
}

