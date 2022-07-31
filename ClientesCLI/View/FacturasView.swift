//
//  FacturasView.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 28/7/22.
//

import SwiftUI

struct FacturasView: View {
    @State var cliente: Cliente
    
    var body: some View {
        VStack {
            if let facturas = cliente.facturas {
                List {
                    ForEach(facturas) { factura in
                        NavigationLink {
                            FacturaDetailView(facturasVM: FacturasVM(cliente: cliente, facturaCliente: factura))
                        } label: {
                            Text("\(factura.descripcion)")
                        }

                    }
                }
            } else {
                Text("No hay facturas para este cliente")
            }
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: FacturaDetailView(facturasVM: FacturasVM(cliente: cliente, facturaCliente: nil))) {
                    Text("Crear factura")
                }
            }
        })
        .navigationTitle("Facturas")
    }
}
