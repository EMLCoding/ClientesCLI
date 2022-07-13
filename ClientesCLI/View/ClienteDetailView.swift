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
    @State var showCambiarImagen = false
    
    var body: some View {
        Form {
            Section {
                TextField("Nombre", text: $clienteDetailVM.nombre)
                TextField("Apellido", text: $clienteDetailVM.apellido)
                TextField("Email", text: $clienteDetailVM.email)
                    .keyboardType(.emailAddress)
            } header: {
                Text("Datos del cliente")
            }
            if let cliente = clienteDetailVM.cliente {
                Section {
                    VStack {
                        if let newImage = clienteDetailVM.imagen {
                            Image(uiImage: newImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                        } else {
                            if let foto = cliente.foto {
                                AsyncImage(url: .getImage.appendingPathComponent(foto), scale: 2) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(20)
                                } placeholder: {
                                    Color.gray
                                }
                            } else {
                                Text("Selecciona una imagen")
                            }
                        }
                        
                        Button(cliente.foto == nil ? "Añadir imagen" : "Cambiar imagen") {
                            showCambiarImagen.toggle()
                        }
                        .padding(.vertical)
                    }
                } header: {
                    Text("Imagen de perfil")
                }
                .sheet(isPresented: $showCambiarImagen) {
                    PHPickerView(cover: $clienteDetailVM.imagen)
                }
            }
            
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
