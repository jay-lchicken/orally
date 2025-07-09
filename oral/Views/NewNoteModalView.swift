//
//  NewNoteModalView.swift
//  oral
//
//  Created by Abinav Gopi on 8/7/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct NewNoteModalView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: NotesViewModel

    @State private var noteTitle: String = ""
    @State private var noteTextContent: String = ""

    @State private var showTextInput = false
    @State private var showImageOptions = false

    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @State private var showFilePicker = false

    @State private var pickedImage: UIImage?
    @State private var pickedFileURL: URL?

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Add New Note")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                TextField("Enter note title", text: $noteTitle)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    Button(action: {
                        showTextInput = true
                    }) {
                        labelWithIcon("Type Text", systemName: "pencil")
                    }

                    Button(action: {
                        showImageOptions = true
                    }) {
                        labelWithIcon("Add Image", systemName: "photo")
                    }

                    Button(action: {
                        showFilePicker = true
                    }) {
                        labelWithIcon("Upload File", systemName: "doc")
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: saveNote) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(noteTitle.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                            .shadow(radius: 1)
                    }
                    .disabled(noteTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $showTextInput) {
                NavigationView {
                    VStack {
                        TextEditor(text: $noteTextContent)
                            .padding()
                            .navigationTitle("Write Text Note")
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done") {
                                        showTextInput = false
                                    }
                                }
                            }
                    }
                }
            }
            // Photo Picker sheet
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPicker(selectedImage: $pickedImage, isPresented: $showPhotoPicker)
            }
            // Camera sheet
            .sheet(isPresented: $showCamera) {
                CameraView(image: $pickedImage, isShown: $showCamera)
            }
            // File picker from Files app
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.pdf, .rtf, .plainText, .image, .spreadsheet, .presentation, .text, .compositeContent],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let first = urls.first {
                        pickedFileURL = first
                    }
                case .failure(let error):
                    print("File import error: \(error.localizedDescription)")
                }
            }
            // Image options as alert-style action sheet
            .confirmationDialog("Add Image", isPresented: $showImageOptions, titleVisibility: .visible) {
                Button("Use Camera") {
                    showCamera = true
                }
                Button("Select from Gallery") {
                    showPhotoPicker = true
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    private func saveNote() {
        let title = noteTitle.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }

        if !noteTextContent.isEmpty {
            viewModel.addTextNote(title: title, content: noteTextContent) {
                isPresented = false
            }
            return
        }

        if let image = pickedImage {
            if let url = saveImageToTempURL(image: image) {
                viewModel.addFileNote(title: title, fileURL: url, type: "image") {
                    isPresented = false
                }
            }
            return
        }

        if let fileURL = pickedFileURL {
            viewModel.addFileNote(title: title, fileURL: fileURL, type: "file") {
                isPresented = false
            }
            return
        }

        // If nothing selected, just dismiss
        isPresented = false
    }

    private func saveImageToTempURL(image: UIImage) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = tempDir.appendingPathComponent(fileName)
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try jpegData.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image to temp URL: \(error.localizedDescription)")
            return nil
        }
    }

    private func labelWithIcon(_ text: String, systemName: String) -> some View {
        HStack {
            Image(systemName: systemName)
                .font(.title2)
            Text(text)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(LinearGradient(colors: [Color.purple, Color.blue], startPoint: .leading, endPoint: .trailing))
        .foregroundColor(.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}


#Preview {
    @Previewable @State var isPresented: Bool = false
    @Previewable @State var viewModel = NotesViewModel()

    
    NewNoteModalView(isPresented: $isPresented, viewModel: viewModel)
}
