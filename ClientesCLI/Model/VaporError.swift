//
//  VaporError.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import Foundation

struct VaporError:Codable {
    let error:Bool
    let reason:String
}

enum APIErrors:Error {
    case noHTTP
    case json(Error)
    case status(Int)
    case general(Error)
    case vapor(String)
    case process
    case request
    
    var description:String {
        switch self {
        case .noHTTP:
            return "No es una conexión HTTP."
        case .json(let error):
            return "Error en el JSON: \(error)."
        case .status(let int):
            return "Estado del servidor \(int)."
        case .general(let error):
            return "Error general \(error)."
        case .vapor(let reason):
            return "Server error: \(reason)."
        case .process:
            return "Error de proceso."
        case .request:
            return "Error con la petición."
        }
    }
}
