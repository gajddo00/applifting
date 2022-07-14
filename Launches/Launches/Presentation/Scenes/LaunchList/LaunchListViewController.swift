//
//  LaunchListViewController.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import UIKit
import Combine

protocol LaunchListViewControllerDelegate: AnyObject {
    //navigate to detail func
}

class LaunchListViewController: UIViewController {
    
    private let launchListView: LaunchListView
    private let viewModel: LaunchListViewModel
    unowned private let coordinator: LaunchListViewControllerDelegate
    private var disposeBag: Set<AnyCancellable> = []
    
    init(_ coordinator: LaunchListViewControllerDelegate, viewModel: LaunchListViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        launchListView = LaunchListView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = launchListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        
        viewModel.getPastLaunches()
    }
    
    private func bindUI() {
        launchListView.tableView.dataSource = self
        
        viewModel.$launches.sink { [weak self] launches in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.launchListView.tableView.reloadData()
            }
        }.store(in: &disposeBag)
    }
}

//MARK: UITableViewDataSource
extension LaunchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(LaunchListCell.self, for: indexPath)
        let launch = viewModel.launches[indexPath.row]
        cell.setup(with: launch)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
}
