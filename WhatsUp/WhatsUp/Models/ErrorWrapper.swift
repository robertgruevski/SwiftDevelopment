//
//  ErrorWrapper.swift
//  WhatsUp
//
//  Created by Robert Gruevski on 10/12/25.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    var guidance: String = ""
}
