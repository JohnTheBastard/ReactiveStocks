//  Created by John D Hearn on 2/25/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation

enum API {
    enum QueryType {
        case batch([Stock])
        case detail(Stock)
    }

    case alphaVantage(QueryType)
    case usFundamentals(QueryType)

    var displayName: String {
        var _displayName: String
        switch self {
        case .alphaVantage:   _displayName = "AlphaVantage"
        case .usFundamentals: _displayName = "US Stocks Fundamentals"
        }
        return _displayName
    }

    var baseURL: URL? {
        let _url: URL?
        switch self {
        case .alphaVantage:   _url = URL(string: "https://www.alphavantage.co/")
        case .usFundamentals: _url = URL(string: "https://api.usfundamentals.com/")
        }

        return _url
    }

    var queryURL: URL? {
        return self.queryComponents?.url
    }

    var queryComponents: URLComponents? {
        var queryURL: URL?
        switch self {
        case .alphaVantage:   queryURL = URL(string: "query", relativeTo: self.baseURL)
        case .usFundamentals: queryURL = URL(string: "v1/companies/xbrl", relativeTo: self.baseURL)
        }

        var _queryComponents = URLComponents(url: queryURL!, resolvingAgainstBaseURL: true)
        _queryComponents?.queryItems = self.queryItems

        return _queryComponents
    }

    var queryItems: [URLQueryItem] {
        var _queryItems: [URLQueryItem]
        let key = Secrets.apiKey(for: self)

        switch self {
        case .alphaVantage(let type):

            switch type {
            case .batch(let stocks):
                let symbols = stocks.map { $0.symbol }
                                    .joined(separator: ",")
                _queryItems =
                    [ URLQueryItem(name: "function", value: "BATCH_STOCK_QUOTES"),
                      URLQueryItem(name: "symbols", value: symbols) ]

            case .detail(let stock):
                _queryItems =
                    [ URLQueryItem(name: "function", value: "TIME_SERIES_DAILY_ADJUSTED"),
                      URLQueryItem(name: "symbol", value: stock.symbol) ]
            }

            _queryItems.append(URLQueryItem(name: "datatype", value: "json"))
            _queryItems.append(URLQueryItem(name: "apikey", value: key))

        case .usFundamentals(_):
            //Not using this for now, converting to Central Index Key is a pain.
            _queryItems =
                [ URLQueryItem(name: "format", value: "json"),
                  URLQueryItem(name: "token", value: key) ]
        }

        return _queryItems
    }
}
