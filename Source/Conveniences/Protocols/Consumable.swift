//  Created by John D Hearn on 3/11/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation

protocol Consumable: Decodable {
    associatedtype Item
    var consumables: [Item] { get }
}
