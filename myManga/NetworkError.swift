//
//  NetworkErrors.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case general(Error)
    case status(Int)
    case noContent
    case json(Error)
    case unknown
    case noHTTP
    case authenticationRequired
    
    public var description: String {
        switch self {
        case .general(let error):
            "Error general: \(error.localizedDescription)"
        case .status(let int):
            "Error de status: \(int)"
        case .noContent:
            "El contenido no se corresponde con lo esperado"
        case .unknown:
            "Error desconocido"
        case .noHTTP:
            "No es una llamada HTTP"
        case .json(let error):
            "Error en el JSON: \(error)"
        case .authenticationRequired:
            "Error de autenticación"
        }
    }
}
