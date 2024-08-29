//
//  NetworkManager.swift
//  ChuckNorrisJokes
//
//  Created by Yuliya Vodneva on 25.08.24.
//

import Foundation

enum NetworkError: Error,CustomStringConvertible {
    case noInternet
    case badResponse
    case badStatusCode(Int)
    case noData
    case somethingWentWrong
    
    var description: String {
        switch self {
        case .noInternet:
            "Нет интернета"
        case .badResponse:
            "Неверный ответ сервера"
        case .badStatusCode (let code):
            "Код ошибки - \(code)"
        case .noData:
            "Нет данных"
        case .somethingWentWrong:
            "Что-то пошло не так!!!"
        }
    }
}

final class NetworkManager {
    
    func getJoke(completion: @escaping ((Result<(String?,String?),NetworkError>) -> Void)) {
        let url = URL(string: "https://api.chucknorris.io/jokes/random")!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.noInternet))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.badResponse))
                return
            }
            
            if !((200..<300).contains(response.statusCode)) {
                completion(.failure(.badStatusCode(response.statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let answer = try JSONDecoder().decode(codableJoke.self, from: data)
                let joke = answer.value
                
                if answer.categories.isEmpty {
                    let category = "no category"
                    completion(.success((joke,category)))
                } else {
                    let category = answer.categories[0]
                    completion(.success((joke,category)))
                }
                
            } catch {
                completion(.failure(.somethingWentWrong))
            }
        }
        task.resume()
    }
}
