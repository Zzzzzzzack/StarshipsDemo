//
//  ZKPersistenceProtocol.swift
//  StarshipsDemo
//
//  Created by Zack on 13/3/22.
//

import Foundation

/// A type to handle the persistence for specific data type
protocol ZKPersistenceProtocol {
    // The date type 
    associatedtype DataType
    
    /// If the data is not existing then  create a new one from database, otherwise update the existing data
    func saveOrUpdate(_ model: DataType, completion:(() -> Void)?)
    
    /// Save or update a list of data from database
    /// If the data is not existing then create new data from database, otherwise update the existing data
    func batchSaveOrUpdate(_ models: [DataType], completion:(() -> Void)?)
    
    /// Delete data from database
    func delete(_ models: [DataType], completion:(() -> Void)?)
    
    /// Delete data from database by predicate
    func deleteData(_ predicate: NSPredicate, completion:(() -> Void)?)
    
    /// Fetch data from database using predicate
    func fetchData(_ predicate: NSPredicate?) -> [DataType]
}
