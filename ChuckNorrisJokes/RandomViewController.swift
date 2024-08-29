//
//  RandomViewController.swift
//  ChuckNorrisJokes
//
//  Created by Yuliya Vodneva on 25.08.24.
//

import UIKit

class RandomViewController: UIViewController {
    
    var viewModel: RandomVMProtocol
    
    private lazy var jokeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Some joke"
        
        return label
    }()
    
    private lazy var getJokeButton: UIButton = {
        let button = UIButton(configuration: .filled(), primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get joke", for: .normal)
        button.addTarget(self, action: #selector(jokeButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(viewModel: RandomVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        bindingViewModel()
    }
    
    @objc func jokeButtonPressed() {
        viewModel.changeStateIfNeeded()
    }
    
    private func bindingViewModel() {
        viewModel.currentState = { [weak self] state in
            guard let self else {return}
            
            switch state {
            case .initial:
                print("initial")
            case .loading:
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                self.jokeLabel.text = "loading joke"
            case .loaded(let joke):
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                self.jokeLabel.text = joke
            case .error(let error):
                print(error.description)
            }
        }
    }
    
    private func setupSubviews() {
        view.addSubview(jokeLabel)
        view.addSubview(getJokeButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            jokeLabel.bottomAnchor.constraint(equalTo: activityIndicator.topAnchor, constant: -30),
            jokeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            jokeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            
            getJokeButton.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 30),
            getJokeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            getJokeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            getJokeButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}

