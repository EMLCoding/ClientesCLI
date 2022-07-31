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

var loginRequest: URL = URL(string: "http://localhost:8080")!
var desa:URL = URL(string: "http://localhost:8080/api")!
let urlBase = desa
let urlLogin = loginRequest

extension URL {
    static let getClientes = urlBase.appendingPathComponent("clientes").appendingPathComponent("page")
    static let cliente = urlBase.appendingPathComponent("cliente")
    static let uploadImage = urlBase.appendingPathComponent("clientes").appendingPathComponent("upload")
    static let getImage = urlBase.appendingPathComponent("uploads").appendingPathComponent("img")
    static let getRegiones = urlBase.appendingPathComponent("clientes").appendingPathComponent("regiones")
    static let login = urlLogin.appendingPathComponent("oauth").appendingPathComponent("token")
    static let getFacturas = urlBase.appendingPathComponent("facturas")
    static let createFactura = urlBase.appendingPathComponent("facturas")
    static let getProductos = urlBase.appendingPathComponent("productos").appendingPathComponent("filtrar-productos")
}

extension URLRequest {
    static func getRequest(url:URL, method:HTTPMethod = .get) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    static func getRequestLogin(url: URL, method: HTTPMethod = .get) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let credentials = "iOSApp:12345".data(using: .utf8)?.base64EncodedString()
        request.setValue("Basic \(credentials ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // Para las peticiones que necesitan estar logueado 
    static func getRequestJWT(url:URL, method:HTTPMethod = .get) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        guard let longToken = SecKeyStore.shared.readKey(label: "JWTTOKEN"),
              let longTokenString = String(data: longToken, encoding: .utf8) else { return nil }
        request.setValue("Bearer \(longTokenString)", forHTTPHeaderField: "Authorization")
        return request
    }
}
