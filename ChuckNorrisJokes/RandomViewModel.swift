//
//  RandomViewModel.swift
//  ChuckNorrisJokes
//
//  Created by Yuliya Vodneva on 26.08.24.
//

import Foundation

enum State {
    case initial
    case loading
    case loaded(String)
    case error(NetworkError)
}

protocol RandomVMProtocol {
    var state: State { get set }
    var currentState: ((State) -> Void)? { get set }
    func changeStateIfNeeded()
}


final class RandomViewModel: RandomVMProtocol {
    
    
    private var networkManager: NetworkManager
    private var storeManager = StoreManager()
    var currentState: ((State) -> Void)?
    
    var state: State = .initial {
        didSet {
            print(state)
            currentState?(state)
        }
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    
    func changeStateIfNeeded() {
        state = .loading
        networkManager.getJoke { [weak self] result in
            guard let self else { return }
            switch result {
            case .success((let joke, let category)):
                storeManager.addJoke(value: joke ?? "", categoryValue: category ?? "")
                DispatchQueue.main.async { [weak self] in
                    self?.state = .loaded(joke ?? "")
                }
            case .failure(let error):
                state = .error(error)
                
            }
        }
    }
}
