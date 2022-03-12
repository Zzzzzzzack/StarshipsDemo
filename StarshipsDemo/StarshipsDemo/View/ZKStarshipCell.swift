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
    
    lazy var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var favourite: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_favourite_off"), for: .normal)
        button.setImage(UIImage(named: "icon_favourite_on"), for: .selected)
        button.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        return button
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
        self.hStack.addArrangedSubview(self.vStack)
        self.hStack.addArrangedSubview(self.favourite)
        self.contentView.addSubview(self.hStack)
        NSLayoutConstraint.activate([
            self.favourite.widthAnchor.constraint(equalToConstant: 50),
            self.hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            self.hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
        // Bind all the related properties with UI
        self.viewModel.$name.sink { [unowned self] in
            // Update name text
            self.name.text = $0
        }.store(in: &self.subscriptions)
        
        self.viewModel.$model.sink { [unowned self] in
            // Update model text
            self.model.text = $0
        }.store(in: &self.subscriptions)
        
        self.viewModel.$manufacturer.sink { [unowned self] in
            // Update manufacturer text
            self.manufacturer.text = $0
        }.store(in: &self.subscriptions)
        
        self.viewModel.$isFavourite.sink { [unowned self] in
            self.favourite.isSelected = ($0 == true)
        }.store(in: &self.subscriptions)
    }
    
    // Handle the click event of favourite button
    @objc
    func toggleFavourite() {
        self.viewModel.toggleFavourite()
    }
}
