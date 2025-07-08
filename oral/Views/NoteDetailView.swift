//
//  NoteDetailView.swift
//  oral
//
//  Created by Abinav Gopi on 8/7/25.
//

import SwiftUI

struct NoteDetailView: View {
    @State var note: Note
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss

    @State private var isEditing = false
    @State private var editedText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(note.title)
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 8)

            if isEditing {
                TextEditor(text: $editedText)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .transition(.opacity.combined(with: .slide))
            } else {
                ScrollView {
                    Text(note.textContent ?? "")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            editedText = note.textContent ?? ""
        }
        .toolbar {
            if note.type == "text" {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        if isEditing {
                            saveEdits()
                        }
                        withAnimation {
                            isEditing.toggle()
                        }
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .bold()
                    }
                }
            }
        }
    }

    private func saveEdits() {
        guard let noteID = note.id else { return }
        viewModel.updateTextNote(id: noteID, newContent: editedText)
        note.textContent = editedText
    }
}
