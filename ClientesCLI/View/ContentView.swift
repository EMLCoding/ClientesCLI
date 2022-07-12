//
//  ContentView.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var clienteVM: ClienteVM
    var body: some View {
        NavigationView {
            List {
                ForEach(clienteVM.clientes) { cliente in
                    ClienteRow(cliente: cliente)
                }
            }
            .alert("Cliente encontrado \(clienteVM.nombrePrueba)", isPresented: $clienteVM.showAlertFindCliente, actions: {
                Button("OK") {
                    clienteVM.showAlertFindCliente = false
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ClienteDetailView(clienteDetailVM: ClienteDetailVM(loadCliente: nil))
                    } label: {
                        Text("Crear")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Prueba") {
                        Task {
                            await clienteVM.getClienteByID(id: UUID(uuidString: "682b28ec-87fa-4d33-bfdb-ac0748d262c5")!)
                        }
                    }
                }
            })
            .navigationTitle("Clientes")
        }
    }
}

struct ClienteRow: View {
    @EnvironmentObject var clienteVM: ClienteVM
    let cliente: Cliente
    
    var body: some View {
        NavigationLink {
            ClienteDetailView(clienteDetailVM: ClienteDetailVM(loadCliente: cliente))
        } label: {
            VStack(alignment: .leading) {
                Text("Nombre: \(cliente.nombre)")
                Text("Apellidos: \(cliente.apellido)")
            }
        }
        .swipeActions {
            Button("Delete") {
                Task {
                    try await clienteVM.deleteCliente(id: cliente.id!)
                }
            }
            .tint(.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
