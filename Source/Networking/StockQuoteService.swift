//  Created by John D Hearn on 2/23/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

let stockQuoteService = StockQuoteService()

class StockQuoteService {
    //TODO: make a directive to customize access control for testing...
    //fileprivate init() { }
    init() { }

    private(set) var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral.then {
            $0.httpMaximumConnectionsPerHost = 8
            $0.allowsCellularAccess = true
            $0.waitsForConnectivity = true
            $0.multipathServiceType = .none  //Not supported by API, unfortunately
            $0.isDiscretionary = true
            $0.timeoutIntervalForRequest = 60
            $0.httpShouldUsePipelining = true
        }

        return URLSession(configuration: config)
    }()

    private let decoder = JSONDecoder()

    var producer: SignalProducer<[Stock], AnyError> {
        return
            self.scheduledRequests
                .flatMap(.latest) { request in self.requestData(request) }
                .flatMap(.latest) { data, response in self.jsonFromDataResponse(data, response) }
                .logEvents()
                .observe(on: UIScheduler())
    }

    private lazy var scheduledRequests: SignalProducer<URLRequest, AnyError> = {
        guard let queryURL = API.alphaVantage.defaultQuery?.url else { return SignalProducer.empty }
        let request = URLRequest(url: queryURL,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 1.0)
        return SignalProducer<URLRequest, AnyError> { (observer, disposable) in
            observer.send(value: request)
            Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
                observer.send(value: request)
            }
        }
    }()

    //MARK: Transforms
    private func requestData(_ request: URLRequest) -> SignalProducer<(Data, URLResponse), AnyError> {
        return self.session.reactive.data(with: request)
                   .withActivityIndicator()
                   .retry(upTo: 2)
                   .on(failed: { (error: AnyError) in
                       print("Network error occurred: \(error as NSError)")
                   })
    }

    private func jsonFromDataResponse(_ data: Data, _ response: URLResponse) -> SignalProducer<[Stock], AnyError> {
        guard let response = response as? HTTPURLResponse else { return SignalProducer.empty }
        if response.statusCode == 200 {
            return self.parseResponse(data)
        } else {
            //TODO: do better error handling here
            print("Network Status Code: \(response.statusCode)")
            return SignalProducer.empty
        }
    }

    // MARK: Helper methods
    private func parseResponse(_ data: Data) -> SignalProducer<[Stock], AnyError> {
        return SignalProducer<[Stock], AnyError> { [unowned self] (observer, disposable) in
            do {
                let quote = try self.decoder.decode(Quote.self, from: data)
                observer.send(value: quote.stocks)
            } catch let decodeError as NSError {
                observer.send(error: AnyError(decodeError))
            }
        }
    }
}

extension StockQuoteService: QueryServiceProvider {
    var queryService: StockQuoteService {
        return self
    }
}
