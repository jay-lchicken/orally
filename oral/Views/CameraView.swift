//
//  CameraView.swift
//  oral
//
//  Created by Abinav Gopi on 8/7/25.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isShown: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.isShown = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


#Preview {
    StatefulPreviewWrapper2(nil as UIImage?, true) { image, isShown in
        CameraView(image: image, isShown: isShown)
    }
}

struct StatefulPreviewWrapper2<A, B, Content: View>: View {
    @State private var value1: A
    @State private var value2: B
    var content: (Binding<A>, Binding<B>) -> Content

    init(_ initial1: A, _ initial2: B, @ViewBuilder content: @escaping (Binding<A>, Binding<B>) -> Content) {
        _value1 = State(initialValue: initial1)
        _value2 = State(initialValue: initial2)
        self.content = content
    }

    var body: some View {
        content($value1, $value2)
    }
}
