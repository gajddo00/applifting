//
//  NetworkProtocol.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func send<Value: Decodable>(
        for request: Request<Value>
    ) -> AnyPublisher<Value, Error>
}
