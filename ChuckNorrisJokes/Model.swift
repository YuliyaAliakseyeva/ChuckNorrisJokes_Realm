//
//  Model.swift
//  ChuckNorrisJokes
//
//  Created by Yuliya Vodneva on 26.08.24.
//

import Foundation
import RealmSwift

class Joke: Object {
    @Persisted var value: String = ""
    @Persisted var category: Category?
    @Persisted var createdDate: Date = Date()
}

class Category: Object {
    @Persisted var title: String = ""
    
}
