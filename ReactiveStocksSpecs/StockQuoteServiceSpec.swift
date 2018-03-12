//  Created by John D Hearn on 3/5/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import Nimble
import Quick
import ReactiveSwift
@testable import ReactiveStocks

class StockDataServiceSpec: QuickSpec {
    var stockDataServiceUnderTest: StockDataService_Testable!
    var stocks: [Stock]!

    override func spec() {
        beforeSuite {
            self.stocks = []
        }
        afterSuite {
            self.stockDataServiceUnderTest = nil
            self.stocks = nil
        }

        describe("StockDataService") {
            context("Retrieve Stocks") {
                self.stockDataServiceUnderTest = StockDataService_Testable()

                it("should start with no stocks") {
                    expect(self.stocks.count).to(equal(0))
                }

                it("should have a quote service") {
                    expect(self.stockDataServiceUnderTest).toNot(beNil())
                }

                let promise = expectation(description: "Status code: 200")

                self.stockDataServiceUnderTest.scheduledStockQuotes.on { result in
                    self.stocks = result
                    promise.fulfill()
                }.start()

                //wait(for: [promise], timeout: 1)

                it("should eventually return 13 stocks") {
                    expect(self.stocks.count).toEventually(equal(13))
                }
            }
        }
    }

    public func testFake() {} //Fixes some problems with Quick/Nimble in Xcode 9
}
