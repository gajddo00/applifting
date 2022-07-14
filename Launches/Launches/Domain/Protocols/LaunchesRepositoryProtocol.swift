//
//  LaunchesRepositoryProtocol.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

protocol LaunchesRepositoryProtocol: AnyObject {
    
    func getPastLaunches(onSuccess: @escaping (Launches) -> (), onError: @escaping (HttpError) -> (), finally: (() -> ())?)
}

