//
//  ContentView.swift
//  MacOSNotesApp
//
//  Created by Robert Gruevski on 10/5/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var notes: [Note] = [
        Note(title: "Welcome", body: "Start writing notes here!")
    ]
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedNote) {
                ForEach(notes) { note in
                    Text(note.title)
                        .tag(note)
                }
            }
            .navigationTitle("My Notes")
            .listStyle(.sidebar)
            .frame(minWidth: 200)
            .toolbar {
                Button("New Note") {
                    let newNote = Note(title: "Untitled", body: "")
                    notes.append(newNote)
                    selectedNote = newNote
                }
            }
        } detail: {
            if let note = selectedNote {
                NoteDetailView(note: binding(for: note))
            } else {
                Text("Select a note")
                    .foregroundStyle(.secondary)
            }
        }
    }
    private func binding(for note: Note) -> Binding<Note> {
        guard let index = notes.firstIndex(where: { $0.id == note.id}) else { fatalError("Note not found") }
        return $notes[index]
    }
}

#Preview {
    ContentView()
}
