//
//  PHPickerView.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 13/7/22.
//

import SwiftUI
import PhotosUI

// El PhotoPicker necesita DELEGADOS
struct PHPickerView: UIViewControllerRepresentable {
    // Lo recibe desde ScoreDetailView
    @Binding var cover: UIImage?
    
    typealias UIViewControllerType = PHPickerViewController
    
    // Debe llamarse Coordinator
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @Binding var cover: UIImage?
        
        init(cover: Binding<UIImage?>) {
            // Los que empiezan por "_" son bindings
            self._cover = cover
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            // Coge el campo "itemProvider" del array
            let itemProviders = results.map(\.itemProvider)
            // Como se ha limitado la seleccion de imagenes a uno, solo nos interesa el primer elemento del array de itemProviders
            if let item = itemProviders.first, item.canLoadObject(ofClass: UIImage.self) {
                // El item tiene una imagen
                item.loadObject(ofClass: UIImage.self) { readerItem, error in
                    guard error == nil else {
                        return
                    }
                    // Hay que tener en cuenta que las imagenes que se copian pueden ocupar mucho, por lo que es aconsejable redimensionar una imagen para que ocupen menos.
                    // Existen dos metodos de las UIImage para redimensionar: "preparingThumbnail" que es síncrono y "prepareThumbnail" que es asíncrono. Si son muchas fotos las que se quieren redimensionar hay que usar el método asíncrono
                    if let uiImage = readerItem as? UIImage,
                       let thumb = uiImage.preparingThumbnail(of: CGSize(width: 500, height: 500)){
                        // Asigna la imagen al binding que recibe desde ScoreDetailView, y automaticamente actualiza la pantalla
                        DispatchQueue.main.async {
                            self.cover = thumb
                        }
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(cover: $cover)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // Limita el numero de fotos que se pueden seleccionar
        configuration.filter = .images // Para mostrar solo las imagenes
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
}
