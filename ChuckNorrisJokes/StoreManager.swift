//
//  StoreManager.swift
//  ChuckNorrisJokes
//
//  Created by Yuliya Vodneva on 26.08.24.
//

import Foundation
import RealmSwift

final class StoreManager {
    
    var jokes: [Joke] = []
    var categories: [Category] = []
    
    init() {
        self.jokes = fetchJokes()
        self.categories = fetchCategories()
    }
    
    func addJoke(value: String, categoryValue: String) {
        let realm = try! Realm()
        
        let arrayOfJokes = realm.objects(Joke.self)
        let arrayOfCategories = realm.objects(Category.self)
        
        let category = Category()
        category.title = categoryValue
        
        let joke = Joke()
        joke.value = value
        joke.createdDate = Date()
        
        let existCategory = arrayOfCategories.where {
            ($0.title) == categoryValue
        }
        let exsistJoke = arrayOfJokes.where{$0.value == value}
        
        if existCategory.isEmpty {
            try! realm.write {
                realm.add(category)
            }
            joke.category = category
        } else {
            print("category already exists")
            joke.category = existCategory[0]
        }
        
        if exsistJoke.isEmpty {
            try! realm.write {
                realm.add(joke)
            }
        } else {
            print("joke already exists")
        }
        
        jokes = fetchJokes()
        categories = fetchCategories()
    }
    
    func deleteJoke(at index: Int) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(jokes[index])
        }
        
        jokes = fetchJokes()
    }
    
    func fetchJokes() -> [Joke] {
        let realm = try! Realm()
        return realm.objects(Joke.self).map {$0}
        
    }
    
    func fetchCategories() -> [Category] {
        let realm = try! Realm()
        
        return realm.objects(Category.self).map {$0}
        
    }
}
