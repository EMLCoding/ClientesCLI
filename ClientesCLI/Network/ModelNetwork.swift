//
//  ModelNetwork.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 10/7/22.
//

import SwiftUI

final class ModelNetwork {
    static let shared = ModelNetwork()
    
    func getClientes(page: Int) async throws -> ClientePagination {
        guard let request = URLRequest.getRequest(url: .getClientes.appendingPathComponent("\(page)")) else { throw APIErrors.request }
        return try await getJSON(request: request, output: ClientePagination.self)
    }
    
    func getClienteById(id: UUID) async throws -> Cliente {
        let request = URLRequest.getRequestJWT(url: .cliente.appendingPathComponent(id.uuidString), method: .get)
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
    
    func uploadImage(imagen: UIImage, idCliente: UUID) async throws -> Bool {
        var request = URLRequest.getRequest(url: .uploadImage, method: .post)
        
        let boundary = UUID().uuidString
        
        let fileParam = "archivo"
        let idParam = "id"
        var body = Data()
        let imageData = imagen.jpegData(compressionQuality: 0.5)
        request?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(idParam)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(idCliente)".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        
        let filename = "profile.jpeg"
        let mimetype = "image/jpeg"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fileParam)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request?.httpBody = body
        
        guard let request = request else { throw APIErrors.request }
        return try await send(request: request)
    }
    
    func getRegiones() async throws -> [Region] {
        guard let request = URLRequest.getRequest(url: .getRegiones) else { throw APIErrors.request }
        return try await getJSON(request: request, output: [Region].self)
    }
    
    func login(username: String, password: String) async throws {
        guard var request = URLRequest.getRequestLogin(url: .login, method: .post) else { throw APIErrors.request }
        
        
        let params: Data = "username=edu&password=12345&grant_type=password".data(using: .utf8)!
        request.httpBody = params
        //let (data, response) = try await URLSession.shared.data(for: request)
        //guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIErrors.process }
        let loginResponse = try await getJSON(request: request, output: LoginRequest.self)
        print(loginResponse)
        let token = Data(loginResponse.accessToken.utf8)
        SecKeyStore.shared.storeKey(key: token, label: "JWTTOKEN")
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
                if (response.statusCode == 401 || response.statusCode == 403) {
                    print("ACCESO NO AUTORIZADO")
                    // Aqui se puede sacar una alerta de acceso no autorizado y poner el boton para ir al login
                }
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
