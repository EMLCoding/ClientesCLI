//
//  ClienteVM.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 11/7/22.
//

import Foundation

final class ClienteVM: ObservableObject {
    
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
    
    func updateCliente(cliente: Cliente) async throws -> Bool{
        do {
            guard let cliente = validateCliente() else {
                return false
            }
            return try await ModelNetwork.shared.updateCliente(cliente: cliente)
        } catch {
            print("Error updating data: \(error)")
            return false
        }
    }
    
    func validateCliente() -> Cliente? {
        cliente?.nombre = self.nombre
        cliente?.apellido = self.apellido
        cliente?.email = self.email
        return cliente
    }
}
