//
//  ModelNetwork.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import Foundation

final class ModelNetwork {
    static let shared = ModelNetwork()
    
    
    
    func getClientes() async throws -> [Cliente] {
        guard let request = URLRequest.getRequest(url: .getClientes) else { throw APIErrors.request }
        return try await getJSON(request: request, output: [Cliente].self)
    }
    
    func getJSON<Output:Codable>(request:URLRequest, output:Output.Type) async throws -> Output {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.dateDecodingStrategy = .formatted(.formatter) // Como en la BBDD se guardan las fechas en formato "yyyy-MM-dd", es necesario que al decodificar el JSON se indique el formato especifico
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.noHTTP }
            if response.statusCode == 200 {
                do {
                    return try decoder.decode(Output.self, from: data)
                } catch {
                    throw APIErrors.json(error)
                }
            } else {
                do {
                    let error = try decoder.decode(VaporError.self, from: data)
                    throw APIErrors.vapor(error.reason)
                } catch let error as APIErrors {
                    throw error
                } catch {
                    throw APIErrors.status(response.statusCode)
                }
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general(error)
        }
    }
}
