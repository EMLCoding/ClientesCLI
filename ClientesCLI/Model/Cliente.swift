//
//  Cliente.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import SwiftUI

struct ClientePagination: Codable {
    let content: [Cliente]
    let pageable: Pageable
        let totalPages, totalElements: Int
        let last: Bool
        let numberOfElements, size: Int
        let first: Bool
        let number: Int
        let sort: Sort
        let empty: Bool
}

struct Cliente: Codable, Identifiable {
    let id: UUID?
    var nombre: String
    var apellido: String
    var email: String
    let foto: String?
    let createAt: Date?
    var region: Region
}

struct Pageable: Codable {
    let sort: Sort
    let pageNumber, pageSize, offset: Int
    let paged, unpaged: Bool
}

struct Sort: Codable {
    let sorted, unsorted, empty: Bool
}

struct CreateCliente: Codable {
    var nombre: String
    var apellido: String
    var email: String
    let createAt: Date?
}
