//
//  ZKStarshipsDBHelper.swift
//  StarshipsDemo
//
//  Created by Zack on 13/3/22.
//

import Foundation

class ZKStarshipsDBHelper: ZKPersistenceProtocol {
    typealias DataType = ZKStarship
    
    static let shared = ZKStarshipsDBHelper()
    
    /// If the data is not existing then  create a new one from database, otherwise update the existing data
    func saveOrUpdate(_ model: ZKStarship, completion: (() -> Void)? = nil) {
        
    }
    
    /// Save or update a list of data from database
    /// If the data is not existing then create new data from database, otherwise update the existing data
    func batchSaveOrUpdate(_ models: [ZKStarship], completion: (() -> Void)? = nil) {
        
    }
    
    /// Delete data from database
    func delete(_ models: [DataType], completion:(() -> Void)? = nil) {
        
    }
    
    /// Delete data from database by predicate, if predicate == nil, this method will delete all the data
    func deleteData(_ predicate: NSPredicate, completion:(() -> Void)? = nil) {
        
    }
    
    /// Fetch data from database using predicate, if predicate == nil, this method will return all the data
    func fetchData(_ predicate: NSPredicate?) -> [DataType] {
        return []
    }
}
