//
//  Requests.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation

extension Request {
    
    static func getPastLaunches() -> Self {
        Request(
            url: "/launches",
            method: .get([])
        )
    }
    
}
