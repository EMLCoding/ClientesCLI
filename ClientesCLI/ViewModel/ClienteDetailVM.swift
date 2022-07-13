//
//  ClienteDetailVM.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 12/7/22.
//

import SwiftUI

final class ClienteDetailVM: ObservableObject {
    
    @Published var nombre = ""
    @Published var apellido = ""
    @Published var email = ""
    @Published var imagen: UIImage?
    
    var cliente: Cliente?
    var isEdition: Bool = false
    
    init(loadCliente: Cliente? = nil) {
        if let cliente = loadCliente {
            self.cliente = cliente
            self.isEdition = true
            self.nombre = cliente.nombre
            self.apellido = cliente.apellido
            self.email = cliente.email
        } else {
            self.isEdition = false
        }
    }
    
    @MainActor
    func createCliente() async throws -> Cliente? {
        do {
            let cliente = prepareCliente()
            return try await ModelNetwork.shared.createCliente(cliente: cliente)
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
            guard let cliente = validateCliente(), let image = imagen else {
                return nil
            }
            
            if let idCliente = cliente.id, try await ModelNetwork.shared.uploadImage(imagen: image, idCliente: idCliente) {
                return try await ModelNetwork.shared.updateCliente(cliente: cliente)
            } else {
                return nil
            }
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
    
    func prepareCliente() -> Cliente {
        return Cliente(id: nil, nombre: self.nombre, apellido: self.apellido, email: self.email, foto: nil, createAt: nil)
    }
    
    func validateCliente() -> Cliente? {
        cliente?.nombre = self.nombre
        cliente?.apellido = self.apellido
        cliente?.email = self.email
        return cliente
    }
}
