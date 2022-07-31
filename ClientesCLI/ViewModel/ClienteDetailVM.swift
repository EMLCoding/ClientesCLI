//
//  ClienteDetailVM.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 12/7/22.
//

import SwiftUI

final class ClienteDetailVM: ObservableObject {
    
    @Published var regiones: [Region] = []
    
    @Published var nombre = ""
    @Published var apellido = ""
    @Published var email = ""
    @Published var imagen: UIImage?
    @Published var regionSeleccionada: Region?
    
    var cliente: Cliente?
    var isEdition: Bool = false
    
    init(loadCliente: Cliente? = nil) {
        if let cliente = loadCliente {
            self.cliente = cliente
            self.isEdition = true
            self.nombre = cliente.nombre
            self.apellido = cliente.apellido
            self.email = cliente.email
            self.regionSeleccionada = cliente.region
        } else {
            self.isEdition = false
        }
        
        Task {
            try await getRegiones()
        }
    }
    
    func prueba() {
        if let regionSeleccionada = regionSeleccionada {
            print(regionSeleccionada.nombre)
        } else {
            print("NO HAY REGION SELECCIONADA")
        }
    }
    
    @MainActor
    func getRegiones() async throws {
        do {
            regiones = try await ModelNetwork.shared.getRegiones()
        } catch {
            print("\(error)")
        }
    }
    
    @MainActor
    func createCliente() async throws -> Cliente? {
        do {
            if let region = regionSeleccionada {
                let cliente = prepareCliente(regionCliente: region)
                return try await ModelNetwork.shared.createCliente(cliente: cliente)
            } else {
                return nil
            }
        } catch {
            if let apiError = error as? APIErrors {
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al crear cliente", text: "\(apiError.description)", textButton: nil))
            } else {
                print("Error creating data: \(error)")
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al crear cliente", text: "\(error)", textButton: nil))
            }
            return nil
        }
    }
    
    @MainActor
    func updateCliente(cliente: Cliente) async throws -> Cliente? {
        do {
            guard let cliente = validateCliente(), let idCliente = cliente.id else {
                return nil
            }
            
            if let image = imagen {
                let _ = try await ModelNetwork.shared.uploadImage(imagen: image, idCliente: idCliente)
            }
            
            return try await ModelNetwork.shared.updateCliente(cliente: cliente)
        } catch {
            if let apiError = error as? APIErrors {
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al actualizar un cliente", text: "\(apiError.description)", textButton: nil))
            } else {
                print("Error updating data: \(error)")
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al actualizar un cliente", text: "\(error)", textButton: nil))
            }
            return nil
        }
    }
    
    func prepareCliente(regionCliente: Region) -> Cliente {
        return Cliente(id: nil, nombre: self.nombre, apellido: self.apellido, email: self.email, foto: nil, createAt: nil, region: regionCliente, facturas: [])
    }
    
    func validateCliente() -> Cliente? {
        cliente?.nombre = self.nombre
        cliente?.apellido = self.apellido
        cliente?.email = self.email
        if let regionSeleccionada = regionSeleccionada {
            cliente?.region = regionSeleccionada
        }
        return cliente
    }
}
