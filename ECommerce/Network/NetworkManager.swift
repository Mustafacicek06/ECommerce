//
//  NetworkManager.swift
//  ECommerce
//
//  Created by Mustafa on 21.12.2024.
//


import Foundation

/// HTTP Method Enum
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Custom Error Enum for Networking
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case unknown(Error)
}

/// NetworkManager Protocol (Interface)
protocol NetworkManagerProtocol {
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String]?,
        parameters: [String: Any]?,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
import Foundation

final class NetworkManager: NetworkManagerProtocol {
    
    // Singleton
    static let shared = NetworkManager()
    private init() { }
    
    // Base URL
    private let baseURL = "https://5fc9346b2af77700165ae514.mockapi.io"
    
    /// Generic Request Method
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + path) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Adding headers
        headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        // Adding body for POST/PUT
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.unknown(error)))
                }
                return
            }
        }
        
        // Perform network request
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.unknown(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(responseType, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume()
    }
}
