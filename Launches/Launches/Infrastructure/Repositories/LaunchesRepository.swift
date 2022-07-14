//
//  LaunchesRepository.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation

class LaunchesRepository: NetworkRepository, LaunchesRepositoryProtocol {
    
    func getPastLaunches(onSuccess: @escaping (Launches) -> (), onError: @escaping (HttpError) -> (), finally: (() -> ())?) {
        let request: Request<Launches> = .getPastLaunches()
        requestSource(request: request, onSuccess: onSuccess, onError: onError, finally: finally)
    }
    
}
