//
//  NetworkRepository.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Combine
import Foundation
import Inject

class NetworkRepository {
    private var disposeBag: Set<AnyCancellable> = []
    
    @AutoWiredSingleton()
    private var networkService: NetworkServiceProtocol
    
    func requestSource<T: Decodable>(request: Request<T>, onSuccess: @escaping (T) -> (), onError: @escaping (HttpError) -> (), finally: (() -> ())? = nil) {
        networkService.send(for: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { failure in
                finally?()
                guard let httpError = failure.mapToHttpError() else { return }
                onError(httpError)
            }, receiveValue: { result in
                onSuccess(result)
            })
            .store(in: &disposeBag)
    }
}
