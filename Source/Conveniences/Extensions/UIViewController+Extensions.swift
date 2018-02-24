//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension UIViewController {
    func addChild(viewController: UIViewController, toView: UIView? = nil) {
        let theView: UIView = toView ?? self.view

        self.addChildViewController(viewController)
        theView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }

    func removeFromParent() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    func setNavigationBackground() {
        let blueImage = UIImage.imageFromColor(Colors.blue.uiColor)
        self.navigationController?.navigationBar.setBackgroundImage(blueImage, for: .default)
        self.navigationController?.navigationBar.tintColor = Colors.white.uiColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func setNavTitle(_ string: String) {
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.set(Attributed.title(string), alignment: .center)
        self.navigationItem.titleView = titleLabel
    }

    @discardableResult
    func setRightButtonToLogo() -> UIView {
        let theFrame = CGRect(x: 0, y: 0, width: 30, height: 30)

        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.frame = theFrame
        button.setImage(UIImage.getScaledImage(imageResourceName: "logo",
                                               size: theFrame.size ),
                        for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        return button
    }

    func setTitleViewToLogo() {
        let theFrame = CGRect(x: 0, y: 0, width: 30, height: 30)

        let logo = UIImageView(image: UIImage.getScaledImage(imageResourceName: "logo",
                                                             size: theFrame.size ))
        logo.isUserInteractionEnabled = true
        logo.contentMode = .center
        logo.frame = theFrame

        self.navigationItem.titleView = logo
    }

    func addCancelButton() {
        let cancelButtonImage = #imageLiteral(resourceName: "cancel")
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: cancelButtonImage,
                            landscapeImagePhone: cancelButtonImage,
                            style: .done,
                            handler: { _ in self.dismiss(animated: true) })
    }
}
