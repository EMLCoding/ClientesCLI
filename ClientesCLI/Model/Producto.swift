//
//  Producto.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 28/7/22.
//

import Foundation

struct Producto: Identifiable, Codable {
    let id: Int
    var nombre: String
    var precio: Double
    var createAt: Date?
}
