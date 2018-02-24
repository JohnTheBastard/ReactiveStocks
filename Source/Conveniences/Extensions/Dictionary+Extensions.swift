//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation

extension Dictionary {
    func value(optionalKey: Key?) -> Value? {
        guard let key = optionalKey else { return nil }
        return self[key]
    }

    func values(optionalKeys: [Key?]) -> [Value]? {
        let keys = optionalKeys.flatMap { $0 }
        guard !keys.isEmpty else { return nil }

        return keys.map { self[$0] }
                   .flatMap { $0 }
    }

    @discardableResult
    mutating func updateValue(_ value: Value, optionalKey: Key?) -> Value? {
        guard let key = optionalKey else { return nil }
        return self.updateValue(value, forKey: key)
    }

    @discardableResult
    mutating func removeValue(optionalKey: Key?) -> Value? {
        guard let key = optionalKey else { return nil }
        return self.removeValue(forKey: key)
    }

    static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }
}

extension Dictionary where Value: Equatable {
    func findKeys(for value: Value) -> [Key] {
        let keys = self.filter({ $0.value == value }).keys

        return Array(keys)
    }

    func findKey(for value: Value) -> Key? {
        let keys = self.filter({ $0.value == value }).keys

        return keys.first
    }

}
