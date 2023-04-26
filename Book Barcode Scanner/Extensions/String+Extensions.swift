//
//  String+Extensions.swift
//  Book Barcode Scanner
//
//  Created by Robert Faist on 3/12/23.
//

import Foundation

extension String {
    func http2https() -> String {
        guard self.hasPrefix("http:") else { return self }
        return self.replacingOccurrences(of: "http", with: "https")
    }
}
