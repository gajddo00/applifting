//
//  LaunchListViewModel.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation
import Inject

class LaunchListViewModel: ObservableObject {
    
    @Published var launches: Launches = []
    
    @Inject()
    private var launchesRepository: LaunchesRepositoryProtocol
    
    func getPastLaunches() {
        launchesRepository.getPastLaunches(
            onSuccess: { [weak self] launches in
                self?.launches = launches
            }, onError: { httpError in
                Logger.log(httpError)
            }, finally: nil)
    }
    
}
