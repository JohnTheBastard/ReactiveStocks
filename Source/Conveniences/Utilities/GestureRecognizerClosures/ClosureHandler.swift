/**
    From: https://github.com/marcbaldwin/GestureRecognizerClosures
*/

import UIKit

let ClosureHandlerSelector = Selector(("handle"))

class ClosureHandler<T: AnyObject>: NSObject {
    var handler: ((T) -> Void)?
    weak var control: T?

    init(handler: @escaping (T) -> Void, control: T? = nil) {
        self.handler = handler
        self.control = control
    }

    @objc func handle() {
        if let control = self.control {
            handler?(control)
        }
    }
}

private var HandlerKey: UInt8 = 0

extension UIGestureRecognizer {
    func setHandler<T: UIGestureRecognizer>(_ instance: T, handler: ClosureHandler<T>) {
        objc_setAssociatedObject(self, &HandlerKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        handler.control = instance
    }

    func handler<T>() -> ClosureHandler<T> {
        return objc_getAssociatedObject(self, &HandlerKey) as! ClosureHandler
    }
}
