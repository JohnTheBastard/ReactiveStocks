//  Created by John D Hearn on 3/10/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation

struct DailySummary {
    var date: Date?
    var open: Float
    var high: Float
    var low: Float
    var close: Float
    var adjustedClose: Float
    var volume: Int
    var dividend: Float
    var splitCoefficient: Float

    static var zero: DailySummary {
        return DailySummary(date: Date(), open: 0.0, high: 0.0, low: 0.0,
                            close: 0.0,  adjustedClose: 0.0, volume: 0,
                            dividend: 0.0, splitCoefficient: 1.0)
    }
}

extension DailySummary: Decodable {
    private enum CodingKeys: String, CodingKey {
        case open     = "1. open"
        case high     = "2. high"
        case low      = "3. low"
        case close    = "4. close"
        case adjusted = "5. adjusted close"
        case volume   = "6. volume"
        case dividend = "7. dividend amount"
        case split    = "8. split coefficient"
    }

    init(from decoder: Decoder) throws {
        let container      = try decoder.container(keyedBy: DailySummary.CodingKeys.self)
        let openString     = try container.decode(String.self, forKey: .open)
        let highString     = try container.decode(String.self, forKey: .high)
        let lowString      = try container.decode(String.self, forKey: .low)
        let closeString    = try container.decode(String.self, forKey: .close)
        let adjustedString = try container.decode(String.self, forKey: .adjusted)
        let volumeString   = try container.decode(String.self, forKey: .volume)
        let dividendString = try container.decode(String.self, forKey: .dividend)
        let splitString    = try container.decode(String.self, forKey: .split)

        if let open             = Float(openString),
           let high             = Float(highString),
           let low              = Float(lowString),
           let close            = Float(closeString),
           let adjustedClose    = Float(adjustedString),
           let volume           = Int(volumeString),
           let dividend         = Float(dividendString),
           let splitCoefficient = Float(splitString) {

            self.open             = open
            self.high             = high
            self.low              = low
            self.close            = close
            self.adjustedClose    = adjustedClose
            self.volume           = volume
            self.dividend         = dividend
            self.splitCoefficient = splitCoefficient
        } else {
            throw ParsingError.failedCast("Unable to cast String values to DailySummary property types.")
        }
    }
}

struct TimeSeries: Decodable {
    private let metaData: TimeSeries.MetaData
    let series: [DailySummary]
    var lastRefresh: Date {
        return self.metaData.lastRefresh
    }

    static let dateFormatter: DateFormatter = {
        var _dateFormatter = DateFormatter()
        _dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        _dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //"yyyy-MM-dd"
        _dateFormatter.timeZone = TimeZone(identifier: "America/New_York")!

        return _dateFormatter
    }()

    private enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case series   = "Time Series (Daily)"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TimeSeries.CodingKeys.self)
        let metaData = try container.decode(TimeSeries.MetaData.self, forKey: .metaData)
        let series = try container.decode([String: DailySummary].self, forKey: .series)

        self.metaData = metaData
        self.series = series.map { (key, value) in
            var mutableValue = value
            mutableValue.date = TimeSeries.dateFormatter.date(from: key)
            return value
        }
    }

    struct MetaData: Decodable {
        var info: String
        var symbol: String
        var lastRefresh: Date
        var outputSize: OutputSize
        var timeZone: TimeZone

        enum OutputSize: String {
            case compact = "Compact"
            case full    = "Full"
        }

        private enum CodingKeys: String, CodingKey {
            case info      = "1. Information"
            case symbol    = "2. Symbol"
            case refresh   = "3. Last Refreshed"
            case output    = "4. Output Size"
            case timeZone  = "5. Time Zone"
        }

        init(from decoder: Decoder) throws {
            do {
                let container = try decoder.container(keyedBy: TimeSeries.MetaData.CodingKeys.self)
                let info      = try container.decode(String.self, forKey: .info)
                let symbol    = try container.decode(String.self, forKey: .symbol)
                let refresh   = try container.decode(String.self, forKey: .refresh)
                let output    = try container.decode(String.self, forKey: .output)
                let tzString  = try container.decode(String.self, forKey: .timeZone)

                self.info        = info
                self.symbol      = symbol

                if tzString == "US/Eastern" {
                    //TODO: We only care about New York for now, but it would be
                    //      cleaner to have an enum for US time zones.
                    self.timeZone = TimeZone(identifier: "America/New_York")!
                } else {
                    throw ParsingError.unrecognizedTimeZone(tzString)
                }


                if let lastRefresh = TimeSeries.dateFormatter.date(from: refresh) {
                    self.lastRefresh = lastRefresh
                } else {
                    throw ParsingError.failedCast("Unable to cast a Date from String: \(refresh)")
                }

                if let outputSize = OutputSize(rawValue: output) {
                    self.outputSize = outputSize
                } else {
                    throw ParsingError.failedCast("Unknown case for TimeSeries.MetaData.OutputSize: \(output)")
                }

            } catch let error as DecodingError {
                print(error)
                self.info = ""
                self.symbol = ""
                self.lastRefresh = Date()
                self.outputSize = .compact
                self.timeZone = TimeZone(identifier: "America/New_York")!
            }
        }
    }
}

extension TimeSeries: Consumable {
    typealias Item = DailySummary
    var consumables: [Item] {
        return self.series
    }
}

