//
//  ZKStarshipDetailCell.swift
//  StarshipsDemo
//
//  Created by Zack on 12/3/22.
//

import UIKit
import Combine

class ZKStarshipDetailCell: UITableViewCell {

    static let identifier = "ZKStarshipDetailCell"
    
    let viewModel = ZKStarshipDetailViewModel()
    private var subscriptions = Set<AnyCancellable>()

    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var detail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.combineWithViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // Setup UI
        self.hStack.addArrangedSubview(self.title)
        self.hStack.addArrangedSubview(self.detail)
        self.contentView.addSubview(self.hStack)
        NSLayoutConstraint.activate([
            self.title.widthAnchor.constraint(equalToConstant: 150),
            self.hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // Combine the UI with view model
    func combineWithViewModel() {
        self.viewModel.$title.sink { [unowned self] in
            // Update title text
            self.title.text = $0
        }.store(in: &self.subscriptions)
        
        self.viewModel.$detail.sink { [unowned self] in
            // Update detail text
            self.detail.text = $0
        }.store(in: &self.subscriptions)
    }
}
