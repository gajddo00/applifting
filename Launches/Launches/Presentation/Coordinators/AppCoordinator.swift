//
//  AppCoordinator.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import UIKit

class AppCoordinator: Coordinator {
    var components: CoordinatorComponents
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.components = CoordinatorComponents(navigationController: UINavigationController())
    }
    
    func begin() {
        window.rootViewController = components.navigationController
        window.makeKeyAndVisible()
        
        startLaunchCoordinator()
    }
}

//MARK: Start
extension AppCoordinator {
    
    private func startLaunchCoordinator() {
        let launchCoordinator = LaunchCoordinator(self, navigationController: components.navigationController)
        addChildCoordinator(launchCoordinator)
        launchCoordinator.begin()
    }
}

//MARK: LaunchCoordinatorDelegate
extension AppCoordinator: LaunchCoordinatorDelegate {
    func launchCoordinatorFinished(_ coordinator: Coordinator) {
        coordinatorDidFinish(coordinator)
    }
}
