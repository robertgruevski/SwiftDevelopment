//
//  NoteDetailView.swift
//  MacOSNotesApp
//
//  Created by Robert Gruevski on 10/5/25.
//

import SwiftUI

struct NoteDetailView: View {
    @Binding var note: Note
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Title", text: $note.title)
                .font(.title)
                .padding(.bottom)
            TextEditor(text: $note.body)
                .font(.body)
                .border(Color.white.opacity(0.5))
        }
        .padding()
        .navigationTitle(note.title)
    }
}

#Preview {
    @State var sampleNote = Note(title: "preview", body: "preview body")
    NoteDetailView(note: $sampleNote)
}
