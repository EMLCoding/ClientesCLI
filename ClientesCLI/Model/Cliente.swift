//
//  Cliente.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import Foundation

struct Cliente: Codable, Identifiable {
    let id: UUID
    var nombre: String
    var apellido: String
    var email: String
    let createAt: Date?
}
