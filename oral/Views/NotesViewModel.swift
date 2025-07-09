//
//  NotesViewModel.swift
//  oral
//
//  Created by Abinav Gopi on 8/7/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import Combine
import FirebaseAuth

struct Note: Identifiable, Codable {
    var id: String?
    var title: String
    var type: String
    var contentURL: String?
    var textContent: String?
    var dateCreated: Date
    var dateDeleted: Date?
    var isDeleted: Bool = false
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var deletedNotes: [Note] = []
    @Published var searchText: String = ""
    @Published var selectedNote: Note?

    private var db = Firestore.firestore()
    private var storage = Storage.storage()

    init() {
        fetchNotes()
        fetchDeletedNotes()
    }

    func fetchNotes() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).collection("notes")
            .whereField("isDeleted", isEqualTo: false)
            .order(by: "dateCreated", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                let allNotes = docs.compactMap { try? $0.data(as: Note.self) }
                DispatchQueue.main.async {
                    self.notes = allNotes.filter { note in
                        self.searchText.isEmpty || note.title.lowercased().contains(self.searchText.lowercased())
                    }
                }
            }
    }

    func fetchDeletedNotes() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).collection("notes")
            .whereField("isDeleted", isEqualTo: true)
            .order(by: "dateDeleted", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                DispatchQueue.main.async {
                    self.deletedNotes = docs.compactMap { try? $0.data(as: Note.self) }
                }
            }
    }

    func filteredNotes(searchText: String) -> [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    func addTextNote(title: String, content: String, completion: (() -> Void)? = nil) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let note = Note(id: nil, title: title, type: "text", contentURL: nil, textContent: content, dateCreated: Date(), dateDeleted: nil, isDeleted: false)
        do {
            try db.collection("users").document(userID).collection("notes").addDocument(from: note)
            completion?()
        } catch {
            print("Error saving text note: \(error)")
        }
    }

    func addFileNote(title: String, fileURL: URL, type: String, completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let fileName = UUID().uuidString
        let ref = storage.reference().child("notes/\(userID)/\(fileName)")

        ref.putFile(from: fileURL) { metadata, error in
            if let error = error {
                print("Upload error: \(error)")
                return
            }

            ref.downloadURL { url, _ in
                guard let downloadURL = url else { return }
                let note = Note(id: nil, title: title, type: type, contentURL: downloadURL.absoluteString, textContent: nil, dateCreated: Date(), dateDeleted: nil, isDeleted: false)
                do {
                    try self.db.collection("users").document(userID).collection("notes").addDocument(from: note)
                    completion()
                } catch {
                    print("Saving note failed: \(error)")
                }
            }
        }
    }

    func deleteNote(_ note: Note) {
        guard let userID = Auth.auth().currentUser?.uid, let noteID = note.id else { return }
        db.collection("users").document(userID).collection("notes").document(noteID).updateData([
            "isDeleted": true,
            "dateDeleted": Date()
        ])
    }

    func restoreNote(_ note: Note) {
        guard let userID = Auth.auth().currentUser?.uid, let noteID = note.id else { return }
        db.collection("users").document(userID).collection("notes").document(noteID).updateData([
            "isDeleted": false,
            "dateDeleted": FieldValue.delete()
        ])
    }

    func permanentlyDeleteNote(_ note: Note) {
        guard let userID = Auth.auth().currentUser?.uid, let noteID = note.id else { return }

        // 1. Delete file from Storage (if exists)
        if let urlString = note.contentURL, let url = URL(string: urlString) {
            let path = "notes/\(userID)/\(url.lastPathComponent)"
            storage.reference(withPath: path).delete { error in
                if let error = error {
                    print("Storage file deletion failed: \(error.localizedDescription)")
                }
            }
        }

        // 2. Delete Firestore document
        db.collection("users").document(userID).collection("notes").document(noteID).delete()
    }

    func cleanUpDeletedNotes() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()

        db.collection("users").document(userID).collection("notes")
            .whereField("isDeleted", isEqualTo: true)
            .whereField("dateDeleted", isLessThan: Timestamp(date: thirtyDaysAgo))
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }

                for doc in docs {
                    let data = doc.data()
                    let urlString = data["contentURL"] as? String
                    if let urlString = urlString, let url = URL(string: urlString) {
                        let path = "notes/\(userID)/\(url.lastPathComponent)"
                        self.storage.reference(withPath: path).delete(completion: nil)
                    }
                    doc.reference.delete()
                }
            }
    }

    func updateTextNote(id: String, newContent: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).collection("notes").document(id).updateData([
            "textContent": newContent
        ]) { error in
            if let error = error {
                print("Failed to update note: \(error.localizedDescription)")
            }
        }
    }
}
