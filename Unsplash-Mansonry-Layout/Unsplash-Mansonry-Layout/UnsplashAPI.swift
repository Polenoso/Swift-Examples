//
//  UnsplashAPI.swift
//  Unsplash-Mansonry-Layout
//
//  Created by Aitor Pagán on 24/10/24.
//
import Foundation
import OSLog

struct Constant {
    static let accessKey = "UNSPLASH ACCESS KEY AFTER REGISTERING AS DEVELOPER"
}

enum UnsplashError: Error, LocalizedError {
    case invalidResponse
    case httpError([String], Int)
    case decodingError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            "Invalid Response".localizedLowercase
        case .httpError(let array, let int):
            "Error de API: Code:\(int) \n Messages: \(array.joined(separator: ",\n"))"
        case .decodingError(let message):
            "Error al decodificar: \(message)"
        }
    }
    
    var errorDescription: String? {
        localizedDescription
    }
    
    var failureReason: String? {
        localizedDescription
    }
}

final class UnsplashAPI {
    func randomPhotos() async throws -> [UnsplashPhoto.Photo] {
        let url = URL(string: "https://api.unsplash.com/photos/random?count=30")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Client-ID \(Constant.accessKey)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw UnsplashError.invalidResponse
        }
        let decoder = JSONDecoder()
        if response.statusCode != 200 {
            let errors = try decoder.decode(UnsplashAPIHTTPError.self, from: data)
            throw UnsplashError.httpError(errors.errors, response.statusCode)
        }
        
        do {
            return try decoder.decode([UnsplashPhoto.Photo].self, from: data)
        } catch {
            throw UnsplashError.decodingError(error.localizedDescription)
        }
    }
}

struct UnsplashAPIHTTPError: Decodable {
    let errors: [String]
}
