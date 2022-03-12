//
//  ZKStarshipCell.swift
//  StarshipsDemo
//
//  Created by Zack on 12/3/22.
//

import UIKit
import Combine

class ZKStarshipCell: UITableViewCell {

    static let identifier = "ZKStarshipCell"
    
    let viewModel = ZKStarshipViewModel()
    private var subscriptions = Set<AnyCancellable>()

    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var model: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var manufacturer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // Setup UI
        self.vStack.addArrangedSubview(self.name)
        self.vStack.addArrangedSubview(self.model)
        self.vStack.addArrangedSubview(self.manufacturer)
        self.contentView.addSubview(self.vStack)
        NSLayoutConstraint.activate([
            self.vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            self.vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
        // Bind all the related properties with UI
        self.viewModel.$name.sink {
            // Update name text
            self.name.text = $0
        }.store(in: &self.subscriptions)
        
        self.viewModel.$model.sink {
            // Update model text
            self.model.text = $0
        }.store(in: &self.subscriptions)
        
        self.viewModel.$manufacturer.sink {
            // Update manufacturer text
            self.manufacturer.text = $0
        }.store(in: &self.subscriptions)
    }
}
