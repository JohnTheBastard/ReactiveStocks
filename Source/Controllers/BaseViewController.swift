//  Created by John D Hearn on 3/5/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

typealias CompletionHandler = (_ success: Bool, _ error: Error?) -> Void
class BaseViewController: UIViewController {

    var closeCompletion: CompletionHandler?
    var appearCompletion: CompletionHandler?

    override var title: String? {
        didSet {
            let text = self.title ?? String()
            self.setNavTitle(text)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Colors.black.uiColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setNavigationBackground()
        self.updateNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.appearCompletion?(true, nil)
        self.appearCompletion = nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Force hide keyboard so it dimisses at the same time as view controller
        self.view.endEditing(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.closeCompletion?(true, nil)
        self.closeCompletion = nil
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func updateNavigationBar() {
        if navigationController?.viewControllers[0] == self {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"),
                                                                    style: UIBarButtonItemStyle.plain,
                                                                    target: self,
                                                                    action: #selector(didTapClose))
        } else {
            let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"),
                                             style: UIBarButtonItemStyle.plain,
                                             target: self,
                                             action: #selector(didTapBack))
            self.navigationItem.leftBarButtonItem = backButton
        }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:String(),
                                                                style:.plain,
                                                                target:nil,
                                                                action:nil)
    }

    @objc func didTapClose() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

