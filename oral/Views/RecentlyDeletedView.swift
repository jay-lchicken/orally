//
//  RecentlyDeletedView.swift
//  oral
//
//  Created by Abinav Gopi on 8/7/25.
//

import SwiftUI

struct RecentlyDeletedView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.gray]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if viewModel.deletedNotes.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "trash")
                            .font(.system(size: 64))
                            .foregroundColor(.white.opacity(0.4))
                        Text("No deleted notes")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.deletedNotes) { note in
                            HStack {
                                Image(systemName: iconName(for: note.type))
                                    .foregroundColor(.white)

                                VStack(alignment: .leading) {
                                    Text(note.title)
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text(NotesViewModel.format(date: note.dateDeleted ?? Date()))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }

                                Spacer()

                                HStack(spacing: 20) {
                                    Button(action: {
                                        viewModel.restoreNote(note)
                                    }) {
                                        Image(systemName: "arrow.uturn.backward")
                                            .foregroundColor(.green)
                                    }

                                    Button(action: {
                                        confirmPermanentDelete(note)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }
            }
            .navigationTitle("Recently Deleted")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.cleanUpDeletedNotes()
            }
        }
    }

    private func confirmPermanentDelete(_ note: Note) {
        guard let noteID = note.id else { return }
        let alert = UIAlertController(title: "Delete Permanently?",
                                      message: "This cannot be undone.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            viewModel.permanentlyDeleteNote(note)
        })

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(alert, animated: true)
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

// MARK: - Static Date Formatter Helper
extension NotesViewModel {
    static func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    RecentlyDeletedView(viewModel: NotesViewModel())
}
