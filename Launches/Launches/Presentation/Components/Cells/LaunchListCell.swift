//
//  LaunchListCell.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import UIKit

class LaunchListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        constrain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Layout
    private func layout() {
        contentView.addSubview(rocketNameLabel)
    }

    //MARK: Constrain
    private func constrain() {
        rocketNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.right.equalTo(contentView).inset(20)
            make.height.equalTo(20)
        }
    }

    func setup(with model: Launch) {
        rocketNameLabel.text = model.details
    }

    //MARK: Lazy vars
    private lazy var rocketNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
}
