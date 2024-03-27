//
//  FetchingService.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import Foundation
import RxRelay
import RxSwift

protocol FetchingServiceProtocol: AnyObject {
    associatedtype T: Decodable
    var relay: PublishRelay<Result<T, NetworkError>> { get set }
    
    func getData(from urlString: String) throws
}

final class FetchingService<T: Decodable>: FetchingServiceProtocol {
    typealias ParsedResult = Result<T, NetworkError>
    private let parser: Parser<T>
    
    public var relay = PublishRelay<ParsedResult>()
    private let disposeBag = DisposeBag()

    init(parser: Parser<T> = Parser<T>()) {
        self.parser = parser
        subscribeOnRelay()
    }

    func getData(from urlString: String) throws {
        guard let url = URL(string: urlString) else {
            self.relay.accept(.failure(NetworkError.invalidURL))
            throw NetworkError.invalidURL
        }
        guard let requst = getRequest(from: url, httpType: .get) else {
            self.relay.accept(.failure(NetworkError.invalidRequest))
            throw NetworkError.invalidRequest
        }
        
        guard let task = createTask(from: requst) else {
            self.relay.accept(.failure(NetworkError.sslError))
            throw NetworkError.sslError
        }
        task.resume()
    }
}

extension FetchingService {
    //MARK: - Private configuration for URLSession task
    private func getRequest(from url: URL, httpType: HTTPType) -> URLRequest? {
       var request = URLRequest(url: url)
       request.httpMethod = httpType.rawValue
       return request
    }
    
    // создает таску
    private func createTask(from urlRequest: URLRequest) -> URLSessionDataTask? {
       let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
           if let error = error as? NSError, error.code == NSURLErrorSecureConnectionFailed {
               print("SSL Error: \(error.localizedDescription)")
               self.relay.accept(.failure(error as! NetworkError))
               return
           }

       self.processTheResponse(response: response)
           
       guard let responseData = data else {
           self.relay.accept(.failure((NetworkError.noData)))
           return
       }
           
       self.parser.decodeJSON(ofType: T.self, from: responseData)
           
       }
       
       return task
    }
       
    // обработка респонса
    private func processTheResponse(response: URLResponse?) {
        guard let httpResponse = response as? HTTPURLResponse else {
            self.relay.accept(.failure(NetworkError.invalidResponse))
            return
          }
            
        if let responseError = self.handleHTTPResponse(httpResponse) {
            self.relay.accept(.failure(responseError))
            return
        }
    }

    // обработка разных случаев респонса
    private func handleHTTPResponse(_ httpResponse: HTTPURLResponse) -> NetworkError? {
        switch httpResponse.statusCode {
        case 200...299:
            return nil
        case 400...499:
            return NetworkError.clientError(httpResponse.statusCode)
        case 500...599:
            return NetworkError.serverError(httpResponse.statusCode)
        default:
            return NetworkError.invalidResponseCode(httpResponse.statusCode)
        }
    }
    
}

//MARK: - Subscribing on relay

extension FetchingService {
    
    private func subscribeOnRelay() {
        parser.relay
            .subscribe(onNext: { [weak self] data in
                self?.relay.accept(data)
            })
            .disposed(by: disposeBag)
    }
    
}
