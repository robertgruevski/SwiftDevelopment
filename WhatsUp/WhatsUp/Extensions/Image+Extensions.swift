//
//  Image+Extensions.swift
//  WhatsUp
//
//  Created by Robert Gruevski on 10/11/25.
//

import Foundation
import SwiftUI

extension Image {
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        return self.resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
