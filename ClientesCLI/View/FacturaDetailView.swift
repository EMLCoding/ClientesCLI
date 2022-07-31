//
//  FacturaDetailView.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 29/7/22.
//

import SwiftUI

struct FacturaDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var facturasVM: FacturasVM
    
    var body: some View {
        VStack {
            Form {
                TextField("Cliente", text: $facturasVM.nombreCliente)
                    .disabled(true)
                
                TextField("Descripción", text: $facturasVM.descripcionFactura)
                
                TextField("Observaciones", text: $facturasVM.observacionesFactura)
            }
            
            if !facturasVM.itemsFactura.isEmpty {
                List {
                    ForEach(facturasVM.itemsFactura) { itemFactura in
                        HStack {
                            Group {
                                Text("Nombre: ")
                                Text("\(itemFactura.producto.nombre)")
                            }
                            
                            Group {
                                Text("Cantidad: ")
                                Text("\(itemFactura.cantidad)")
                            }
                            
                            Group {
                                Text("Precio total: ")
                                Text("\(itemFactura.producto.precio * Double(itemFactura.cantidad))")
                            }
                        }
                    }
                }
            }
            
            if !facturasVM.isEdition {
                TextField("Buscar producto", text: $facturasVM.textoProducto)
                    .padding()
                List {
                    ForEach(facturasVM.productos) { producto in
                        VStack {
                            Text("Nombre producto: \(producto.nombre)")
                            Text("Precio: \(producto.precio) €" )
                        }
                        .onTapGesture {
                            facturasVM.addItemFactura(producto: producto)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !facturasVM.isEdition {
                    Button("Añadir") {
                        Task {
                            try await facturasVM.createFactura()
                            dismiss()
                        }
                        
                    }
                }
                
            }
        }
    }
}

