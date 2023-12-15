//
//  ResponseAdapter.swift
//
//
//  Created by Alex Crowe on 2023-12-15.
//

import Foundation

public protocol ResponseAdapter {
    func response<T: Decodable>(for data: Data, response: URLResponse) throws -> T
}

struct GenericResponseAdapter: ResponseAdapter {
    
    let successCodeRange: [Int]
    private let decoder = JSONDecoder()
    
    func response<T: Decodable>(for data: Data, response: URLResponse) throws -> T {
        if let httpResponse = response as? HTTPURLResponse,
           !successCodeRange.isEmpty && !successCodeRange.contains(httpResponse.statusCode) {
            throw GenericNetworkError(body: data, code: httpResponse.statusCode)
        }
        return try decoder.decode(T.self, from: data)
    }
    
}

struct GenericResponse<T: Decodable> {
    let body: T
}


struct GenericNetworkError: Error {
    let body: Data
    let code: Int
}
