//  Created by John D Hearn on 3/5/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import Nimble
import Quick
import ReactiveSwift
@testable import ReactiveStocks

class StockQuoteServiceSpec: QuickSpec {
    var quoteServiceUnderTest: StockQuoteService!
    var stocks: [Stock]!

    override func spec() {
        afterSuite {
            self.quoteServiceUnderTest = nil
            self.stocks = nil
        }

        describe("StockQuoteService") {
            context("Retrieve Stocks") {
                self.quoteServiceUnderTest = StockQuoteService()
                self.stocks = []

                it("should have a quote service") {
                    expect(self.quoteServiceUnderTest).toNot(beNil())
                }

                it("should start with no stocks") {
                    expect(self.stocks.count).to(equal(0))
                }

                let promise = expectation(description: "Status code: 200")

                self.quoteServiceUnderTest.producer.on { result in
                    self.stocks = result
                    promise.fulfill()
                }.start()

                wait(for: [promise], timeout: 3)

                it("should eventually return 13 stocks") {
                    expect(self.stocks.count).toEventually(equal(13))
                }
            }
        }
    }
}
