//
//  Factura.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 28/7/22.
//

import Foundation

struct Factura: Identifiable, Codable {
    let id: Int?
    var descripcion: String
    var observacion: String
    var createAt: Date?
    
    var cliente: Cliente?
    var items: [ItemFactura]
}

struct ItemFactura: Identifiable, Codable {
    let id: Int?
    var cantidad: Int
    var producto: Producto
}
