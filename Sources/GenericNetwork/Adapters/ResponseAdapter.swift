//
//  ResponseAdapter.swift
//
//
//  Created by Alex Crowe on 2023-12-15.
//

import Foundation

public protocol ResponseAdapter {
    func response<T: Decodable>(for data: Data, response: URLResponse) throws -> T
    
    func response(for url: URL, response: URLResponse) throws -> URL
}

struct GenericResponseAdapter: ResponseAdapter {
    
    let successCodeRange: [Int]
    private let decoder = JSONDecoder()
    
    func response<T: Decodable>(for data: Data, response: URLResponse) throws -> T {
        try validate(response: response, for: data)
        return try decoder.decode(T.self, from: data)
    }
    
    func response(for url: URL, response: URLResponse) throws -> URL {
        try validate(response: response, for: url)
        return url
    }
    
    private func validate<T>(response: URLResponse, for data: T) throws {
        if let httpResponse = response as? HTTPURLResponse,
           !successCodeRange.isEmpty && !successCodeRange.contains(httpResponse.statusCode) {
            throw GenericNetworkError(body: data, code: httpResponse.statusCode)
        }
    }
}



public func DefaultResponseAdapter() -> ResponseAdapter {
    GenericResponseAdapter(successCodeRange: Array((200...299)))
}


struct GenericResponse<T: Decodable> {
    let body: T
}


struct GenericNetworkError<T>: Error {
    let body: T
    let code: Int
}
