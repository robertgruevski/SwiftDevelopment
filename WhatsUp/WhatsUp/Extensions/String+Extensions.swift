//
//  String+Extensions.swift
//  WhatsUp
//
//  Created by Robert Gruevski on 10/11/25.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
