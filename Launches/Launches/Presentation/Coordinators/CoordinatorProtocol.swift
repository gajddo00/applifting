//
//  CoordinatorProtocol.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import UIKit

protocol FlowDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

struct ModalConfiguration {
    var presentationStyle: UIModalPresentationStyle
    
    init(presentationStyle: UIModalPresentationStyle) {
        self.presentationStyle = presentationStyle
    }
}

struct CoordinatorComponents {
    var childCoordinators: [Coordinator] = []
    var viewControllers: [UIViewController] = []
    var navigationController: UINavigationController
    var modalPresenter: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

protocol Coordinator: FlowDelegate {
    var components: CoordinatorComponents { get set }
    func begin()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        components.childCoordinators.append(coordinator)
    }
    
    //MARK: Navigation stack methods
    func push(_ viewController: UIViewController, animated: Bool = true) {
        components.viewControllers.append(viewController)        
        components.navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        if components.viewControllers.last == components.navigationController.viewControllers.last {
            let vc = components.navigationController.popViewController(animated: animated)
            ///controller was not popped, is the last one in the navigationViewController
            if vc == nil && components.navigationController.viewControllers.count == 1 {
                components.navigationController.setViewControllers([], animated: false)
            }
            
        } ///else the VC was popped with gesture
        
        _ = components.viewControllers.popLast()
    }
    
    func popTo(_ viewController: UIViewController, animated: Bool = false) {
        if let index = components.viewControllers.lastIndex(of: viewController) {
            for _ in ((index + 1)..<components.viewControllers.count).reversed() {
                components.navigationController.popViewController(animated: animated)
                _ = components.viewControllers.popLast()
            }
        } else {
            debugPrint("Tring to pop to nonexistent ViewController.")
        }
    }
    
    func remove(_ type: UIViewController.Type) {
        let targetViewController = findTargetViewController(type)
        
        if let targetViewController = targetViewController {
            var currentStack = components.navigationController.viewControllers
            if let targetIndex = currentStack.firstIndex(of: targetViewController) {
                currentStack.remove(at: targetIndex)
                components.navigationController.setViewControllers(currentStack, animated: false)
            }
        }
    }
    
    private func findTargetViewController(_ type: UIViewController.Type) -> UIViewController? {
        var targetViewController: UIViewController?
        
        for i in (0..<components.viewControllers.count).reversed() {
            let vc = components.viewControllers[i]
            if components.viewControllers[i].isKind(of: type) {
                targetViewController = vc
            }
        }
        
        return targetViewController
    }
    
    func popTo(_ type: UIViewController.Type, animated: Bool = false) {
        let targetViewController = findTargetViewController(type)
        
        if let targetViewController = targetViewController {
            popTo(targetViewController, animated: animated)
        }
    }
    
    func popAll(_ coordinator: Coordinator) {
        let navigationStackCount = coordinator.components.navigationController.viewControllers.count
        let viewControllersCount = coordinator.components.viewControllers.count
        
        for i in 0..<viewControllersCount {
            let lastIndex = viewControllersCount - 1 - i
            if coordinator.components.viewControllers[lastIndex] == coordinator.components.navigationController.viewControllers.last {
                coordinator.components.navigationController.popViewController(animated: coordinator.components.viewControllers.count == 1)
            }
        }
        
        let newNavigationStackCount = coordinator.components.navigationController.viewControllers.count
        let lastVCNotPopped = navigationStackCount - coordinator.components.viewControllers.count != newNavigationStackCount
        
        if lastVCNotPopped && newNavigationStackCount == 1 {
            if coordinator.components.viewControllers.first == coordinator.components.navigationController.viewControllers.last {
                coordinator.components.navigationController.setViewControllers([], animated: false)
            }
        }
        
        coordinator.components.viewControllers.removeAll()
    }
    
    //MARK: Modal presentation methods
    func present(_ viewController: UIViewController, _ configuration: ModalConfiguration, animated: Bool = true, completion: (() -> ())? = nil) {
        viewController.modalPresentationStyle = configuration.presentationStyle
        
        if let last = components.navigationController.viewControllers.last {
            if let presented = last.presentedViewController {
                presented.present(viewController, animated: animated, completion: completion)
            } else {
                last.present(viewController, animated: animated, completion: completion)
            }
            
            return
        }
        
        let presenter = UIViewController()
        push(presenter, animated: false)
        presenter.present(viewController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> ())? = nil) {
        guard let last = components.navigationController.viewControllers.last,
              let presented = last.presentedViewController else {
            debugPrint("No viewController to use for presenting...")
            return
        }
        
        presented.dismiss(animated: animated, completion: completion)
        
        if last == components.modalPresenter {
            pop(animated: false)
            components.modalPresenter = nil
        }
    }
    
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        popAll(coordinator)
        _ = components.childCoordinators.popLast()
    }
}
