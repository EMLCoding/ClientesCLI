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
    
    func createCliente() async throws -> Cliente? {
        do {
            let cliente = prepareCliente()
            return try await ModelNetwork.shared.createCliente(cliente: cliente)
        } catch {
            print("Error creating data: \(error)")
            return nil
        }
    }
    
    func updateCliente(cliente: Cliente) async throws -> Cliente? {
        do {
            guard let cliente = validateCliente() else {
                return nil
            }
            return try await ModelNetwork.shared.updateCliente(cliente: cliente)
        } catch {
            print("Error updating data: \(error)")
            return nil
        }
    }
    
    func prepareCliente() -> Cliente {
        return Cliente(id: nil, nombre: self.nombre, apellido: self.apellido, email: self.email, createAt: nil)
    }
    
    func validateCliente() -> Cliente? {
        cliente?.nombre = self.nombre
        cliente?.apellido = self.apellido
        cliente?.email = self.email
        return cliente
    }
}
