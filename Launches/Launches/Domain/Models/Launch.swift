//
//  Launch.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation

typealias Launches = [Launch]

struct Launch: Decodable {
    var rocket: String?
    var details: String?    
}
