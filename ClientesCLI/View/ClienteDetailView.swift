//
//  ClienteView.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 11/7/22.
//

import SwiftUI

struct ClienteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var clienteVM: ClienteVM
    @ObservedObject var clienteDetailVM: ClienteDetailVM
    @State var showAlert = false
    
    var body: some View {
        Form {
            TextField("Nombre", text: $clienteDetailVM.nombre)
            TextField("Apellido", text: $clienteDetailVM.apellido)
            TextField("Email", text: $clienteDetailVM.email)
                .keyboardType(.emailAddress)
        }
        .alert(clienteDetailVM.isEdition ? "Cliente actualizado correctamente" : "Cliente creado correctamente", isPresented: $showAlert, actions: {
            Button {
                showAlert = false
                dismiss()
            } label: {
                Text("Continuar")
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(clienteDetailVM.isEdition ? "Actualizar" : "Crear") {
                    Task {
                        if clienteDetailVM.isEdition {
                            if let cliente = clienteDetailVM.cliente {
                                if let clienteActualizado = try await clienteDetailVM.updateCliente(cliente: cliente) {
                                    clienteVM.updateClientesList(cliente: clienteActualizado)
                                    showAlert = true
                                }
                            }
                        } else {
                            if let clienteCreado = try await clienteDetailVM.createCliente() {
                                clienteVM.addClientesList(cliente: clienteCreado)
                                dismiss()
                            }
                        }
                        
                    }
                }
            }
        })
        .navigationTitle("Cliente")
    }
}

struct ClienteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClienteDetailView(clienteDetailVM: ClienteDetailVM())
    }
}
