//
//  Cliente.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import SwiftUI

struct Cliente: Codable, Identifiable {
    let id: UUID?
    var nombre: String
    var apellido: String
    var email: String
    let createAt: Date?
}

struct CreateCliente: Codable {
    var nombre: String
    var apellido: String
    var email: String
    let createAt: Date?
}
