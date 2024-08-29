//
//  AllViewController.swift
//  ChuckNorrisJokes
//
//  Created by Yuliya Vodneva on 25.08.24.
//

import UIKit
import RealmSwift

class AllViewController: UIViewController {
    
    private var storeManager = StoreManager()
    var jokes: [Joke] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "All downloaded jokes"
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        jokes = storeManager.fetchJokes()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension AllViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        let arrayOfJoke = jokes.sorted(by: {$0.createdDate > $1.createdDate})
        config.text = arrayOfJoke[indexPath.row].value
        config.secondaryText = arrayOfJoke[indexPath.row].createdDate.formatted()
        cell.contentConfiguration = config
        return cell
    }
}
