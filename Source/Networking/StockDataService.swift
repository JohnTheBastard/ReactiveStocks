//  Created by John D Hearn on 2/23/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

let stockDataService = StockDataService()

class StockDataService {
    fileprivate init() { }

    private let decoder = JSONDecoder()

    private(set) lazy var session: DHURLSession = {
        let config = URLSessionConfiguration.ephemeral.then {
            $0.httpMaximumConnectionsPerHost = 8
            $0.allowsCellularAccess = true
            $0.waitsForConnectivity = true
            $0.multipathServiceType = .none  //Not supported by API, unfortunately
            $0.isDiscretionary = true
            $0.timeoutIntervalForRequest = 60
            $0.httpShouldUsePipelining = true
        }

        let session = URLSession(configuration: config)
        return DHURLSession(urlSession: session)
    }()

    private(set) lazy var scheduledStockQuotes: SignalProducer<[Stock], AnyError> = {
        return self.scheduler(type: Quote.self,
                              api: .alphaVantage(.batch(Example.all)),
                              interval: 60.0)
    }()

    func getDetails(for stock: Stock) -> SignalProducer<[DailySummary], AnyError> {
        return self.scheduler(type: TimeSeries.self,
                              api: .alphaVantage(.detail(stock)),
                              interval: 3600.0)
    }

    func request(api: API, interval seconds: Double) -> SignalProducer<URLRequest, AnyError> {
        guard let queryURL = api.queryURL else {
            let error = ApiError.unableToConstructQuery("Unable to construct Query")
            return SignalProducer.error(error)
        }
        let request = URLRequest(url: queryURL,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 1.0)
        return SignalProducer<URLRequest, AnyError> { (observer, disposable) in
            observer.send(value: request)
            Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { _ in
                observer.send(value: request)
            }
        }
    }

    //MARK: Transforms
    fileprivate func requestData(_ request: URLRequest) -> SignalProducer<(Data, URLResponse), AnyError> {
        return self.session.reactive.data(with: request)
                   .withActivityIndicator()
                   .retry(upTo: 2)
                   .on(failed: { (error: AnyError) in
                       print("Network error occurred: \(error as Error)")
                   })
    }

    fileprivate func consumeJSON<T: Consumable>(_ type: T.Type,
                                                from data: Data,
                                                and response: URLResponse) -> SignalProducer<[T.Item], AnyError> {
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            return self.decodeResponse(type, from: data)
        } else {
            let error = NetworkingError(response: response)
            return SignalProducer.error(error)
        }
    }

    // MARK: Helper methods
    fileprivate func scheduler<T: Consumable>(type: T.Type,
                                              api: API,
                                              interval seconds: Double) -> SignalProducer<[T.Item], AnyError> {
        return self.request(api: api, interval: seconds)
                   .flatMap(.latest) { request in self.requestData(request) }
                   .flatMap(.latest) { data, response in self.consumeJSON(type, from: data, and: response) }
                   .logEvents()
                   .observe(on: UIScheduler())
    }

    fileprivate func decodeResponse<T: Consumable>(_ type: T.Type, from data: Data) -> SignalProducer<[T.Item], AnyError> {
        return SignalProducer<[T.Item], AnyError> { [unowned self] (observer, disposable) in
            do {
                print(data)
                let t = try self.decoder.decode(type, from: data)
                observer.send(value: t.consumables)
            } catch let decodeError as NSError {
                observer.send(error: AnyError(decodeError))
            }
        }
    }
}

extension StockDataService: QueryServiceProvider {
    var queryService: StockDataService {
        return self
    }
}

//MARK: Testable subclass
#if DEBUG //A wrapper class to expose [file]private methods for unit testing.
class StockDataService_Testable: StockDataService {
    public var mockSession: DHURLSessionProtocol?

    public override init() { super.init() }

    public override func getDetails(for stock: Stock) -> SignalProducer<[DailySummary], AnyError> {
        return super.getDetails(for: stock)
    }
    public override func request(api: API, interval seconds: Double) -> SignalProducer<URLRequest, AnyError> {
        return super.request(api: api, interval: seconds)
    }
    public override func requestData(_ request: URLRequest) -> SignalProducer<(Data, URLResponse), AnyError> {
        guard let mockSession = self.mockSession else { return super.requestData(request) }

        let producer = SignalProducer<(Data, URLResponse), AnyError> { (observer, disposable) in
            let task = mockSession.dataTask(with: request) { (data, response, error) in
                if let data = data, let response = response {
                    observer.send(value: (data, response))
                } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    observer.send(error: AnyError(NetworkingError(response: response)))
                } else if let error = error {
                    observer.send(error: AnyError(error))
                }
            }

            task.resume()
        }

        return producer.retry(upTo: 2)
                       .on(failed: { (error: AnyError) in
                           print("Network error occurred: \(error as Error)")
                        })
    }

    public override func consumeJSON<T: Consumable>(_ type: T.Type, from data: Data,
                                                    and response: URLResponse) -> SignalProducer<[T.Item], AnyError> {
        return super.consumeJSON(type, from: data, and: response)
    }
    public override func scheduler<T: Consumable>(type: T.Type, api: API,
                                                  interval seconds: Double) -> SignalProducer<[T.Item], AnyError> {
        return super.scheduler(type: type, api: api, interval: seconds)
    }
    public override func decodeResponse<T: Consumable>(_ type: T.Type, from data: Data) -> SignalProducer<[T.Item], AnyError> {
        return super.decodeResponse(type, from: data)
    }
}
#endif
