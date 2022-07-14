//
//  LaunchListView.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import UIKit
import SnapKit

class LaunchListView: UIView {
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constrain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func constrain() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    //MARK: Lazy vars
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(LaunchListCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .systemGray        
        return tableView
    }()
}
