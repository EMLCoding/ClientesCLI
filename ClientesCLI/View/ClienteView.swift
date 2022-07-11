//
//  ClienteView.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 11/7/22.
//

import SwiftUI

struct ClienteView: View {
    @StateObject var clienteVM: ClienteVM
    @State var showAlert = false
    
    var body: some View {
        Form {
            TextField("Nombre", text: $clienteVM.nombre)
            TextField("Apellido", text: $clienteVM.apellido)
            TextField("Email", text: $clienteVM.email)
                .keyboardType(.emailAddress)
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Actualizar") {
                    Task {
                        if let cliente = clienteVM.cliente {
                           showAlert = try await clienteVM.updateCliente(cliente: cliente)
                        }
                    }
                }
            }
        })
        .navigationTitle("Cliente")
    }
}

struct ClienteView_Previews: PreviewProvider {
    static var previews: some View {
        ClienteView(clienteVM: ClienteVM())
    }
}
