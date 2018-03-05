# ReactiveStocks
A simple stocks app. ReactiveSwift is used to update stock quotes every minute.

TODO: Implement stock detail view and test suite.

## Getting Started
### Step 1:
It's bad form to publish API keys in public repos, so  in order to build this app, you will need to add your own API keys. These can be generated for free as follows:

1. To recieve real-time stock quotes, you need to generate a key for AlphaVantage, which you can do here:
https://www.alphavantage.co/support/#api-key

2. ~~To search for new stock symbols, you will need to generate a key for USFundamentals.com, which you can do here:~~
~~https://account.usfundamentals.com~~

### Step 2:
Once you have your keys, add a new file called `Secrets.swift`  to the Xcode project file under the group `ReactiveStocks > Source > Networking`.

Cut and paste the following code into `Secrets.swift`.

```swift
import Foundation

struct Secrets {
    static func apiKey(for api: API) -> String {
        let _key: String?
        switch api {
        case .alphaVantage:   _key = "<Insert AlphaVantage Key>"
        case .usFundamentals: _key = ""
        }

        return _key ?? "demo"
    }
}
```
Then cut and paste you the key you generated in Step 1 into the string literal for `.alphaVantage` where specified. (Ignore `.usFundamentals` for now.)

### Step 3
Build the app.