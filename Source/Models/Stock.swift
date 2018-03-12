//  Created by John D Hearn on 2/23/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation

struct Stock {
    var symbol: String
    var price: Float?
    var volume: String?
    var date: Date?
    var timeSeries: [DailySummary] = []

    var displayName: String {
        return Example(rawValue: self.symbol)?.displayName ?? self.symbol
    }

    init(_ symbol: String) {
        self.symbol = symbol
    }
}

extension Stock: Decodable {
    static let dateFormatter: DateFormatter = {
        var _dateFormatter = DateFormatter()
        _dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        _dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        _dateFormatter.timeZone = TimeZone(identifier: "America/New_York")!

        return _dateFormatter
    }()

    private enum CodingKeys: String, CodingKey {
        case symbol    = "1. symbol"
        case price     = "2. price"
        case volume    = "3. volume"
        case timestamp = "4. timestamp"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Stock.CodingKeys.self)
        let symbol = try container.decode(String.self, forKey: .symbol)
        let priceString = try container.decode(String.self, forKey: .price)
        let volume = try container.decode(String.self, forKey: .volume)
        let dateString = try container.decode(String.self, forKey: .timestamp)

        self.symbol = symbol
        self.volume = volume

        if let price = Float(priceString),
           let date = Stock.dateFormatter.date(from: dateString) {

            self.price = price
            self.date = date
        } else {
            throw ParsingError.failedCast("Unable to cast String values to Stock property types.")
        }
    }
}

struct Quote: Decodable {
    private let metaData: [String: String]
    let stocks: [Stock]

    private enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case stocks   = "Stock Quotes"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Quote.CodingKeys.self)
        let metaData = try container.decode([String: String].self, forKey: .metaData)
        self.metaData = metaData
        let stocks = try container.decode([Stock].self, forKey: .stocks)
        self.stocks = stocks
    }
}

extension Quote: Consumable {
    typealias Item = Stock
    var consumables: [Item] {
        return self.stocks
    }
}

enum Example: String, EnumCollection {
    case adobe     = "ADBE"
    case apple     = "AAPL"
    case cisco     = "CISC"
    case facebook  = "FB"
    case google    = "GOOG"
    case ibm       = "IBM"
    case intel     = "INTC"
    case microsoft = "MSFT"
    case nike      = "NKE"
    case nvidia    = "NVDA"
    case oracle    = "ORCL"
    case snap      = "SNAP"
    case twitter   = "TWTR"
    case vmware    = "VMW"

    var stock: Stock {
        return Stock(self.rawValue)  //TODO: Change this once we have a store to reference
    }

    var displayName: String {
        let _displayName: String
        switch self {
        case .adobe:     _displayName = "Adobe"
        case .apple:     _displayName = "Apple"
        case .cisco:     _displayName = "Cisco"
        case .facebook:  _displayName = "Facebook"
        case .google:    _displayName = "Alphabet"
        case .ibm:       _displayName = "IBM"
        case .intel:     _displayName = "Intel"
        case .microsoft: _displayName = "Microsoft"
        case .nike:      _displayName = "Nike"
        case .nvidia:    _displayName = "NVidia"
        case .oracle:    _displayName = "Oracle"
        case .snap:      _displayName = "Snap"
        case .twitter:   _displayName = "Twitter"
        case .vmware:    _displayName = "VMWare"
        }
        return _displayName
    }

    static var all: [Stock] {
        return Example.cases().map { $0.stock }
    }
}
