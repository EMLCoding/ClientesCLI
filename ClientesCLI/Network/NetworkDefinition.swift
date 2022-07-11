//
//  NetworkDefinition.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import Foundation

enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

var desa:URL = URL(string: "http://localhost:8080/api")!
let urlBase = desa

extension URL {
    static let getClientes = urlBase.appendingPathComponent("clientes")
    static let cliente = urlBase.appendingPathComponent("cliente")
}

extension URLRequest {
    static func getRequest(url:URL, method:HTTPMethod = .get) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
