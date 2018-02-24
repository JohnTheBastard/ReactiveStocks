//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import ReactiveSwift

extension SignalProducer {
    func delay(_ interval: TimeInterval) -> SignalProducer<Value, Error> {
        return delay(interval, on: QueueScheduler.main)
    }

    static func delay(_ interval: TimeInterval) -> SignalProducer<Value, Error> {
        return empty.delay(interval)
    }

    func startingWith(value: Value) -> SignalProducer<Value, Error> {
        return SignalProducer<Value, Error>(value: value).concat(self.producer)
    }

    func deferred(interval: TimeInterval) -> SignalProducer<Value, Error> {
        return SignalProducer.empty
            .delay(interval)
            .concat(self.producer)
    }

    func deferredRetry(interval: TimeInterval, count: Int = .max) -> SignalProducer<Value, Error> {
        precondition(count >= 0)

        if count == 0 {
            return producer
        }

        var retries = count
        return flatMapError { error in
            // The final attempt shouldn't defer the error if it fails
            var producer = SignalProducer<Value, Error>(error: error)
            if retries > 0 {
                producer = producer.deferred(interval: interval)
            }

            retries -= 1
            return producer
            }
            .retry(upTo: count)
    }
}

