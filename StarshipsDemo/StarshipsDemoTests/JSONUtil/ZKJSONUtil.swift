//
//  ZKJSONUtil.swift
//  StarshipsDemoTests
//
//  Created by Zack on 12/3/22.
//

import Foundation

class ZKJSONUtil {
    static let shared = ZKJSONUtil()
    
    /// Load data from JSON file
    /// - Parameters:
    ///   - dataType: A decodable type
    ///   - fileName: The JSON file name
    func loadDataFromJSONFile<DataType>(_ dataType: DataType.Type, fileName: String) throws -> DataType? where DataType: Decodable {
        let path = Bundle(for: type(of:self)).path(forResource: fileName, ofType: "json")
        let url = URL(fileURLWithPath: path ?? "")
        let jsonData = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(DataType.self, from: jsonData)
        return response
    }
}
