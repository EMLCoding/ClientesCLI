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
    
    func getClienteById(id: UUID) async throws -> Cliente {
        let request = URLRequest.getRequest(url: .cliente.appendingPathComponent(id.uuidString), method: .get)
        guard let request = request else { throw APIErrors.request }
        return try await getJSON(request: request, output: Cliente.self) 
    }
    
    func createCliente(cliente: Cliente) async throws -> Cliente {
        var request = URLRequest.getRequest(url: .cliente, method: .post)
        let encoder = getEncoder()
        request?.httpBody = try? encoder.encode(cliente)
        guard let request = request else { throw APIErrors.request }
        return try await getJSON(request: request, output: Cliente.self)
    }
    
    func updateCliente(cliente: Cliente) async throws -> Cliente {
        var request = URLRequest.getRequest(url: .cliente.appendingPathComponent(cliente.id?.uuidString ?? ""), method: .put)
        let encoder = getEncoder()
        request?.httpBody = try? encoder.encode(cliente)
        guard let request = request else { throw APIErrors.request }
        return try await getJSON(request: request, output: Cliente.self)
    }
    
    func deleteCliente(id: UUID) async throws -> Bool {
        let request = URLRequest.getRequest(url: .cliente.appendingPathComponent(id.uuidString), method: .delete)
        guard let request = request else { throw APIErrors.request }
        return try await send(request: request)
    }
    
    func getJSON<Output:Codable>(request:URLRequest, output:Output.Type) async throws -> Output {
        do {
            let decoder = getDecoder()
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
    
    func send(request:URLRequest) async throws -> Bool {
        do {
            let decoder = getDecoder()
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.noHTTP }
            if response.statusCode == 200 {
                return true
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
