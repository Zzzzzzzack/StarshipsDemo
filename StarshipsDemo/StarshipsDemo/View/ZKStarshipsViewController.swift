//
//  StarshipsViewController.swift
//  StarshipsDemo
//
//  Created by Zack on 11/3/22.
//

import UIKit
import Combine

class ZKStarshipsViewController: UIViewController {

    let viewModel = ZKStarshipsViewModel()
    private var subscriptions = Set<AnyCancellable>()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ZKStarshipCell.self, forCellReuseIdentifier: ZKStarshipCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup() {
        // Setup UI
        self.title = "Starships"
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        // Bind the starships so table view will reload once the starships been updated
        self.viewModel.$reloadData
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
            // Reload once the starships been updated
            self.tableView.reloadData()
        }.store(in: &self.subscriptions)
        
        // Trigger view model to get the starship
        self.viewModel.getStarships()
    }
}

extension ZKStarshipsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.starships?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZKStarshipCell.identifier, for: indexPath)
        
        if let starships = self.viewModel.starships,
            starships.count > indexPath.row,
            let cell = cell as? ZKStarshipCell {
            /// Update cell's view mode
            cell.viewModel.update(starships[indexPath.row])
            cell.viewModel.starshipsViewModel = self.viewModel
        }

        return cell
    }
}

extension ZKStarshipsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Equals to cell content height
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as? ZKStarshipCell
        let detailsPage = ZKStarshipDetailsViewController()
        // `isFavourite` can be changed from details page
        // Use the same view model so the changes can be observed by cell
        detailsPage.viewModel = cell?.viewModel
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailsPage, animated: true)
    }
}
