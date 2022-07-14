//
//  LaunchCoordinator.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation
import UIKit

protocol LaunchCoordinatorDelegate: FlowDelegate {
    func launchCoordinatorFinished(_ coordinator: Coordinator)
}

class LaunchCoordinator: Coordinator {
    var components: CoordinatorComponents
    unowned private let flowDelegate: LaunchCoordinatorDelegate
    
    init(_ flowDelegate: LaunchCoordinatorDelegate, navigationController: UINavigationController) {
        self.flowDelegate = flowDelegate
        components = CoordinatorComponents(navigationController: navigationController)
    }
    
    func begin() {
        startLaunchListScreen()
    }
}

//MARK: Start
extension LaunchCoordinator {
    
    private func startLaunchListScreen() {
        let viewModel = LaunchListViewModel()
        let launchViewController = LaunchListViewController(self, viewModel: viewModel)
        push(launchViewController)
    }
    
    private func makeLaunchDetailScreen() {
        
    }    
}

//MARK: LaunchListViewControllerDelegate
extension LaunchCoordinator: LaunchListViewControllerDelegate {
    
}
