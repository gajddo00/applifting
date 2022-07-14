//
//  Logger.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation

struct Logger {
    static func log(_ value: Any...) {
#if DEBUG
        print(value)
#endif
    }
}
