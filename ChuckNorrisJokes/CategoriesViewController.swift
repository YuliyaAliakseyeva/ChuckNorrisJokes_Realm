//
//  CategoriesViewController.swift
//  ChuckNorrisJokes
//
//  Created by Yuliya Vodneva on 25.08.24.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    private var storeManager = StoreManager()
    var categories: [Category] = []
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Categories of jokes"
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        categories = storeManager.fetchCategories()
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

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        config.text = categories[indexPath.row].title
        config.secondaryText = String(" jokes")
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategoryVC = SelectedCategoryViewController()
        let currentCategory = categories[indexPath.row]
        
        selectedCategoryVC.jokes = storeManager.fetchJokes().filter{
            ($0.category!.title) == currentCategory.title
            }
        navigationController?.pushViewController(selectedCategoryVC, animated: true)
    }
}
