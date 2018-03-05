//  Created by John D Hearn on 2/27/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not find collection view cell with identifier \(T.identifier)")
        }
        return cell
    }

    func cellForItem<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
        guard let cell = cellForItem(at: indexPath) as? T else {
            fatalError("Could not get cell as type \(T.self)")
        }
        return cell
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier,
                                             for: indexPath) as? T else { return nil }
        return cell
    }

    func cellForRow<T: UITableViewCell>(at indexPath: IndexPath) -> T? {
        guard let cell = cellForRow(at: indexPath) as? T else {
            fatalError("Could not get cell as type \(T.self)")
        }
        return cell
    }
}
