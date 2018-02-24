//  Created by John Hearn on 2/23/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

protocol DisplayableItem: TextDisplayable, ImageDisplayable { }

protocol TextDisplayable {
    var displayName: String { get }
    var displaySubtitle: String? { get }
}

protocol ImageDisplayable {
    var photoUrl: URL? { get }
    var photo: UIImage? { get }
    //var icon: Icon { get }
}

extension TextDisplayable {
    var displaySubtitle: String? {
        return nil
    }
}

extension UIImage: DisplayableItem {
    var displayName: String { return String() }
    var photoUrl: URL? { return nil }
    var photo: UIImage? { return self }
    //var icon: Icon { return .BlankIcon }
}
