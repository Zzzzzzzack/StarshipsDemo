//
//  ZKStarshipDetailsViewController.swift
//  StarshipsDemo
//
//  Created by Zack on 12/3/22.
//

import UIKit
import Combine

class ZKStarshipDetailsViewController: UIViewController {

    var viewModel: ZKStarshipViewModel?

    private var subscriptions = Set<AnyCancellable>()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZKStarshipDetailCell.self, forCellReuseIdentifier: ZKStarshipDetailCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var favourite: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_favourite_off"), for: .normal)
        button.setImage(UIImage(named: "icon_favourite_on"), for: .selected)
        button.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        return button
    }()
    
    lazy var favouriteBarItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem.init(customView: self.favourite)
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup() {
        // Setup UI
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        self.navigationItem.rightBarButtonItem = self.favouriteBarItem
        
        // Bind all the related properties with UI
        self.viewModel?.$name.sink { [unowned self] in
            // Reload once the starships been updated
            self.title = $0
        }.store(in: &self.subscriptions)
        
        self.viewModel?.$displayDetailTypes.sink { [unowned self] _ in
            self.tableView.reloadData()
        }.store(in: &self.subscriptions)
        
        self.viewModel?.$isFavourite.sink { [unowned self] in
            self.favourite.isSelected = ($0 == true)
        }.store(in: &self.subscriptions)
    }
    
    // Handle the click event of favourite button
    @objc
    func toggleFavourite() {
        self.viewModel?.toggleFavourite()
    }
}

extension ZKStarshipDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Display all the eligible details
        return self.viewModel?.displayDetailTypes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZKStarshipDetailCell.identifier, for: indexPath)
        if let cell = cell as? ZKStarshipDetailCell, let displayDetailTypes = self.viewModel?.displayDetailTypes,
            displayDetailTypes.count > indexPath.row {
            let detailType = displayDetailTypes[indexPath.row]
            // Display each of the details by type
            cell.viewModel.update(self.viewModel?.starship, detailType: detailType)
        }
        
       return cell
    }
}

extension ZKStarshipDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
