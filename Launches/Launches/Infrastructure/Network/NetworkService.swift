//
//  NetworkLayer+Session.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation
import Combine
import Alamofire

class NetworkService: NetworkServiceProtocol {
    
    func send<Value>(for request: Request<Value>) -> AnyPublisher<Value, Error> where Value : Decodable {
        makeRequest(for: request)
    }
}

extension NetworkService {
    
    func makeRequest<Value: Decodable>(
        for request: Request<Value>
    ) -> AnyPublisher<Value, Error> {
        
        AF.request(request.urlRequest)
            .validate()
            .publishDecodable(type: Value.self)
            .tryMap { response in
                guard
                    let data = response.data,
                    let urlResponse = response.response else {
                    throw HttpError.network
                }
                
                try self.handleUrlResponse(data: data, response: urlResponse)
                
                if let value = response.value {
                    return value
                } else {
                    throw HttpError.decoding
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func handleUrlResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HttpError.unknown("No HTTP response")
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            let error = httpResponse.statusCode.mapHTTPError(response: data)
            throw error
        }
    }
}

//MARK: Int HTTP codes
extension Int {
    func mapHTTPError(response: Data? = nil) -> HttpError {
        let error: HttpError
        switch self {
        case 400:
            error = .badRequest(response)
        case 401:
            error = .unauthorized(response)
        case 403:
            error = .forbidden(response)
        case 404:
            error = .notFound(response)
        case 500:
            error = .internalServerError(response)
        case 502:
            error = .badGateway(response)
        case 503:
            error = .unavailable(response)
        default:
            error = .unknown("HTTP code \(self)")
        }
        return error
    }
}
