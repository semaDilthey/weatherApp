//
//  Parser.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import Foundation
import RxRelay
import RxSwift

protocol Parsable: AnyObject {
    associatedtype T
    var relay: PublishRelay<Result<T, NetworkError>> { get }
    
    func decodeJSON(ofType: T.Type, from data: Data?)
}

final class Parser<T: Decodable>: Parsable {
    
    typealias ParsedResult = Result<T, NetworkError>
    public var relay = PublishRelay<ParsedResult>()

    func decodeJSON(ofType: T.Type, from data: Data?) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = data else {
            relay.accept(.failure(NetworkError.noData))
            return
        }

        do {
            let parsedData = try decoder.decode(T.self, from: data) // Specify type here
            relay.accept(.success(parsedData))
        } catch {
            relay.accept(.failure(NetworkError.jsonParsingFailed))
        }
    }
}
