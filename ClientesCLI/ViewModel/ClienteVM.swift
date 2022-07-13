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
    @Published var showButtonMoreClientes = false
    
    var page = 0
    
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
            let clienteResponse = try await ModelNetwork.shared.getClientes(page: page)
            clientes.append(contentsOf: clienteResponse.content)
            if (!clienteResponse.last) {
                showButtonMoreClientes = true
                page += 1
            } else {
                showButtonMoreClientes = false
            }
        } catch {
            print("\(error)")
        }
    }
    
    func cargarMasClientes() {
        Task {
            await getClientes()
        }
    }
    
    func getClienteByID(id: UUID) async {
        do {
            let response = try await ModelNetwork.shared.getClienteById(id: id)
            nombrePrueba = response.nombre
            showAlertFindCliente = true
        } catch {
            if let apiError = error as? APIErrors {
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al obtener un cliente", text: "\(apiError.description)", textButton: nil))
            } else {
                print("Error updating data: \(error)")
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al obtener un cliente", text: "\(error)", textButton: nil))
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
            if let apiError = error as? APIErrors {
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al eliminar un cliente", text: "\(apiError.description)", textButton: nil))
            } else {
                print("Error updating data: \(error)")
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al eliminar un cliente", text: "\(error)", textButton: nil))
            }
        }
    }
}
