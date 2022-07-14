//
//  NetworkLayer.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation
import Combine

//MARK: HttpMethod
enum HttpMethod: Equatable {
    case get([URLQueryItem])
    case put(Data?)
    case post(Data?)
    case delete
    case head
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
}

//MARK: HttpError
enum HttpError: Error, Equatable {
    case network
    case badRequest(_ response: Data? = nil)
    case forbidden(_ response: Data? = nil)
    case unauthorized(_ response: Data? = nil)
    case notFound(_ response: Data? = nil)
    case internalServerError(_ response: Data? = nil)
    case badGateway(_ response: Data? = nil)
    case unavailable(_ response: Data? = nil)
    case unknown(_ : String)
    case interrupted
    case decoding
    
    func get() -> Data? {
        switch self {
        case .badRequest(let response),
                .notFound(let response),
                .forbidden(let response),
                .unavailable(let response),
                .internalServerError(let response),
                .unauthorized(let response),
                .badGateway(let response):
            return response
        default: return nil
        }
    }
    
    func mapToResponse<T: Decodable>(type: T.Type) -> T? {
        if let responseData = self.get() {
            guard let data = responseData.decodeTo(type: type) else {
                Logger.log("Error decoding stream response")
                return nil
            }
            
            return data
        }
        
        return nil
    }
}

//MARK: Request
struct Request<Response> {
    let url: String
    let method: HttpMethod
    var headers: [String: String] = [
        "Content-Type": "application/json",
    ]
    var baseUrl = AppConfiguration.APIBaseUrl
}

extension Request {
    var urlRequest: URLRequest {
        guard let url = URL(string: baseUrl + url) else {
            fatalError("Failed to create request URL.")
        }
        
        var request = URLRequest(url: url)
        
        Logger.log("\(url)")
        Logger.log("\(headers["Authorization"] ?? "")")
        
        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        case let .get(queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components...")
            }
            request = URLRequest(url: url)
        default:
            break
        }
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }
}

//MARK: Encodable
extension Encodable {
    func json() -> Data {
        guard let data = try? JSONEncoder().encode(self) else {
            fatalError("Could not encode data.")
        }
        
        return data
    }
}

//MARK: Data
extension Data {
    func decodeTo<T: Decodable>(type: T.Type) -> T? {
        do {
            let obj = try JSONDecoder().decode(type, from: self)
            return obj
        } catch {
            Logger.log(error.localizedDescription)
            return nil
        }
    }
}

//MARK: Subscribers.Completion
extension Subscribers.Completion {
    func mapToHttpError() -> HttpError? {
        if case .failure(let err) = self, let error = err as? HttpError {
            return error
        }
        return nil
    }
}
