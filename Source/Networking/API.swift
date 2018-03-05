//  Created by John D Hearn on 2/25/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation

enum API: String {
    case alphaVantage   = "AlphaVantage"
    case usFundamentals = "US Stocks Fundamentals"

    var baseURL: URL! {
        let _url: URL?
        switch self {
        case .alphaVantage:   _url = URL(string: "https://www.alphavantage.co/")
        case .usFundamentals: _url = URL(string: "https://api.usfundamentals.com/")
        }

        return _url!
    }

    var queryUrlComponents: URLComponents! {
        var queryURL: URL
        switch self {
        case .alphaVantage:   queryURL = URL(string: "query", relativeTo: self.baseURL)!
        case .usFundamentals: queryURL = URL(string: "v1/companies/xbrl", relativeTo: self.baseURL)!
        }

        return URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
    }

    var defaultQuery: URLComponents! {
        var _defaultQuery = self.queryUrlComponents
        _defaultQuery?.queryItems = self.queryItems()
        return _defaultQuery!
    }

    func queryItems(for stocks: [Stock] = Example.all) -> [URLQueryItem] {
        let _queryItems: [URLQueryItem]
        let key = Secrets.apiKey(for: self)

        switch self {
        case .alphaVantage:
            let symbols = stocks.map { $0.symbol }
                .joined(separator: ",")
            _queryItems =
                [ URLQueryItem(name: "function", value: "BATCH_STOCK_QUOTES"),
                  URLQueryItem(name: "symbols", value: symbols),
                  URLQueryItem(name: "datatype", value: "json"),
                  URLQueryItem(name: "apikey", value: key) ]
        case .usFundamentals:
            //Not using this for now, converting to Central Index Key is a pain.
            _queryItems =
                [ URLQueryItem(name: "format", value: "json"),
                  URLQueryItem(name: "token", value: key) ]
        }

        return _queryItems
    }
}

