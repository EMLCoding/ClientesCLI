//
//  Cliente.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import Foundation

struct Cliente: Codable, Identifiable {
    let id: UUID
    let nombre: String
    let apellido: String
    let email: String
    let createAt: Date?
}
