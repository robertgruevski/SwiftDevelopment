//
//  Note.swift
//  MacOSNotesApp
//
//  Created by Robert Gruevski on 10/5/25.
//

import SwiftUI
import Foundation

struct Note: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var body: String
}
