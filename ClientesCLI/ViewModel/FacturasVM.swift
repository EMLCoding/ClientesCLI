//
//  FacturasVM.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 28/7/22.
//

import SwiftUI

final class FacturasVM: ObservableObject {
    
    var cliente: Cliente
    
    @Published var textoProducto = "" {
        didSet {
            Task {
                try await loadProductos()
            }
        }
    }
    
    @Published var facturas: [Factura]
    @Published var factura: Factura?
    @Published var itemsFactura: [ItemFactura] = []
    @Published var productos: [Producto] = []
    
    @Published var nombreCliente = ""
    @Published var descripcionFactura = ""
    @Published var observacionesFactura = ""
    @Published var productoSeleccionado: Producto?
    
    @Published var isEdition = false
    
    init(cliente: Cliente, facturaCliente: Factura?) {
        self.cliente = cliente
        if let facturas = cliente.facturas {
            self.facturas = facturas
        } else {
            self.facturas = []
        }
        
        if let facturaCargada = facturaCliente {
            self.factura = facturaCargada
            self.isEdition = true
            
            self.descripcionFactura = facturaCargada.descripcion
            self.observacionesFactura = facturaCargada.observacion
            self.itemsFactura = facturaCargada.items
        }
        
        self.nombreCliente = cliente.nombre
        
        if !isEdition {
            Task {
                try await loadProductos()
            }
        }
        
    }
    
    @MainActor
    func loadProductos() async throws {
        do {
            productos = try await ModelNetwork.shared.getProductosBy(nombre: textoProducto)
        } catch {
            if let apiError = error as? APIErrors {
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al obtener los productos", text: "\(apiError.description)", textButton: nil))
            } else {
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al obtener los productos", text: "\(error)", textButton: nil))
            }
        }
    }
    
    func addItemFactura(producto: Producto) {
        if let indexProductoExistente = itemsFactura.firstIndex(where: { $0.producto.id == producto.id }) {
            itemsFactura[indexProductoExistente].cantidad += 1
        } else {
            let itemFactura = ItemFactura(id: nil, cantidad: 1, producto: producto)
            itemsFactura.append(itemFactura)
        }
    }
    
//    func loadFacturaById(facturaID: Int) async throws {
//        do {
//            factura = try await ModelNetwork.shared.getFacturaBy(id: facturaID)
//        } catch {
//            if let apiError = error as? APIErrors {
//                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al obtener las facturas", text: "\(apiError.description)", textButton: nil))
//            } else {
//                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al obtener las facturas", text: "\(error)", textButton: nil))
//            }
//        }
//    }
    
    func createFactura() async throws {
        do {
            let factura = Factura(id: nil, descripcion: descripcionFactura, observacion: observacionesFactura, createAt: Date.now, cliente: cliente, items: itemsFactura)
            
            let facturaCreada = try await ModelNetwork.shared.createFactura(factura: factura)
            
            facturas.append(facturaCreada)
        } catch {
            if let apiError = error as? APIErrors {
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al crear la factura", text: "\(apiError.description)", textButton: nil))
            } else {
                NotificationCenter.default.post(name: .showAlert, object: AlertData(title: "Error al crear la factura", text: "\(error)", textButton: nil))
            }
        }
    }
    
    func updateFactura() {
        
    }
    
    func deleteFactura() {
        
    }
}
