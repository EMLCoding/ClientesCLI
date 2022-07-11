//
//  ContentView.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.clientes) { cliente in
                    NavigationLink {
                        ClienteView(clienteVM: ClienteVM(loadCliente: cliente))
                    } label: {
                        ClienteRow(cliente: cliente)
                    }
                }
            }
            .navigationTitle("Clientes")
        }
        .task {
            await vm.getClientes()
        }
        
    }
}

struct ClienteRow: View {
    let cliente: Cliente
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Nombre: \(cliente.nombre)")
            Text("Apellidos: \(cliente.apellido)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
