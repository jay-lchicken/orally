//
//  NotesView.swift
//  oral
//
//  Created by Abinav Gopi on 6/7/25.
//

import SwiftUI

struct NotesView: View {
    @StateObject var viewModel = NotesViewModel()
    @State private var showingNewNoteModal = false
    @State private var showingFilePreview = false
    @State private var fileToPreview: URL?
    @State private var selectedNoteForDetail: Note?

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("Search notes...", text: $viewModel.searchText)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top)

                    // ✅ Moved outside List
                    let filteredNotes = viewModel.notes.filter {
                        viewModel.searchText.isEmpty ||
                        $0.title.lowercased().contains(viewModel.searchText.lowercased())
                    }

                    List {
                        ForEach(filteredNotes) { note in
                            Button {
                                if note.type == "text" {
                                    selectedNoteForDetail = note
                                } else if let urlString = note.contentURL, let url = URL(string: urlString) {
                                    fileToPreview = url
                                    showingFilePreview = true
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: iconName(for: note.type))
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .frame(width: 30)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(note.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(viewModel.dateString(note.dateCreated))
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.deleteNote(note)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    showingNewNoteModal = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                }
            }
            .sheet(isPresented: $showingNewNoteModal) {
                NewNoteModalView(isPresented: $showingNewNoteModal, viewModel: viewModel)
            }
            .sheet(item: $selectedNoteForDetail) { note in
                NoteDetailView(note: note, viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilePreview) {
                if let fileURL = fileToPreview {
                    FilePreviewView(fileURL: fileURL)
                }
            }
        }
    }

    private func iconName(for type: String) -> String {
        switch type {
        case "text": return "doc.text"
        case "image": return "photo"
        case "file": return "doc"
        default: return "questionmark"
        }
    }
}

#Preview {
    NotesView()
}
