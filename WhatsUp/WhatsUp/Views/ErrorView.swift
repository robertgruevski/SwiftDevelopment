//
//  ErrorView.swift
//  WhatsUp
//
//  Created by Robert Gruevski on 10/12/25.
//

import SwiftUI

struct ErrorView: View {
    
    let errorWrapper: ErrorWrapper
    
    var body: some View {
        VStack {
            Text("An error has occured!")
                .font(.title)
                .padding(.bottom)
            
            Text(errorWrapper.error.localizedDescription)
                .font(.headline)
            
            Text(errorWrapper.guidance)
                .font(.caption)
                .padding(.top)
            
            Spacer()
        }.padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
    }
}

#Preview {
    
    enum SampleError: Error {
        case operationFailed
    }
    
    return ErrorView(errorWrapper: ErrorWrapper(error: SampleError.operationFailed, guidance: "Operation has failed. Please try again later."))
}
