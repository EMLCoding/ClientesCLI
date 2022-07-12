//
//  ClienteVM.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 11/7/22.
//

import SwiftUI

final class ClienteVM: ObservableObject {
    
    @Published var clientes: [Cliente] = []
    @Published var showAlertFindCliente = false
    
    // Es simplemente para la alerta que sale con la prueba de buscar un cliente por ID
    @Published var nombrePrueba = ""
    
    init() {
        Task {
            await getClientes()
        }
    }
    
    @MainActor
    func getClientes() async {
        do {
            clientes = try await ModelNetwork.shared.getClientes()
        } catch {
            print("\(error)")
        }
    }
    
    func getClienteByID(id: UUID) async {
        do {
            let response = try await ModelNetwork.shared.getClienteById(id: id)
            nombrePrueba = response.nombre
            showAlertFindCliente = true
        } catch {
            if let apiError = error as? APIErrors {
                print(apiError.description)
            } else {
                print("ERROR PRUEBA GET CLIENTE \(error)")
            }
        }
    }
    
    func addClientesList(cliente: Cliente) {
        clientes.append(cliente)
    }
    
    func updateClientesList(cliente: Cliente) {
        if let index = clientes.firstIndex(where: { $0.id == cliente.id} ) {
            clientes[index] = cliente
        }
    }
    
    @MainActor
    func deleteCliente(id: UUID) async throws {
        do {
            if try await ModelNetwork.shared.deleteCliente(id: id) {
                if let index = clientes.firstIndex(where: { $0.id == id} ) {
                    clientes.remove(at: index)
                }
            }
        } catch {
            print("Error updating data: \(error)")
        }
    }
}
