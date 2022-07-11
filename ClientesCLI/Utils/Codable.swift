//
//  Codable.swift
//  ClientesCLI
//
//  Created by Eduardo Martin Lorenzo on 11/7/22.
//

import Foundation

func getDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.dateDecodingStrategy = .formatted(.formatter) // Como en la BBDD se guardan las fechas en formato "yyyy-MM-dd", es necesario que al decodificar el JSON se indique el formato especifico
    return decoder
}

func getEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.dateEncodingStrategy = .formatted(.formatter) // Como en la BBDD se guardan las fechas en formato "yyyy-MM-dd", es necesario que al decodificar el JSON se indique el formato especifico
    return encoder
}
