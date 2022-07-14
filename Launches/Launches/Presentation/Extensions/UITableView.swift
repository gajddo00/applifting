//
//  UITableView.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import UIKit

extension UITableView {
    public func cellIdentifier<T: UITableViewCell>(for cellType: T.Type) -> String {
        return String(describing: cellType)
    }
    
    public func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        let name = cellIdentifier(for: cellType)
        register(cellType, forCellReuseIdentifier: name)
    }

    public func dequeueCellForIndexPath<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        let name = cellIdentifier(for: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: name, for: indexPath) as? T else {
            fatalError("You have to register the cell! tableView.register(\(name).self")
        }
        return cell
    }
}
