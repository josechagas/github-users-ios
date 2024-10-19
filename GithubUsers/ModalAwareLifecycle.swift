//
//  ModalAwareLifecycle.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 09/08/24.
//

import UIKit

@objc
public protocol ModalAwareLifecycle: AnyObject {
    func viewDidDismissModal(viewWasOutOfWindow: Bool)
}

fileprivate extension ModalAwareLifecycle where Self: UIViewController {
    typealias DismissAction = (_ animated: Bool, _ completion: (() -> Void)?) -> Void
    typealias DismissCompletionCallback = () -> Void

    func dismiss(animated flag: Bool,
                  completion: DismissCompletionCallback?,
                  superDismissRef: DismissAction) {
        let isPresentingModal = self.presentedViewController != nil
        let presentedBy = isPresentingModal ? self : presentingViewController
        let presentedModal = presentedBy?.presentedViewController
        let hasBeenAddedToWindow = presentedBy?.hasBeenAddedToWindow ?? false
        superDismissRef(flag) {
            let wasDismissed = (presentedModal?.hasBeenAddedToWindow ?? false) == false
            if wasDismissed {
                presentedBy?.viewDidDismissModal(viewWasOutOfWindow: !hasBeenAddedToWindow)
            }
            completion?()
        }
    }
}

extension UINavigationController {
    public override func viewDidDismissModal(viewWasOutOfWindow: Bool) {
        topViewController?.viewDidDismissModal(viewWasOutOfWindow: viewWasOutOfWindow)
    }
}

extension UITabBarController {
    public override func viewDidDismissModal(viewWasOutOfWindow: Bool) {
        selectedViewController?.viewDidDismissModal(viewWasOutOfWindow: viewWasOutOfWindow)
    }
}

extension UISplitViewController {
    public override func viewDidDismissModal(viewWasOutOfWindow: Bool) {
        let primaryVC = viewController(for: .primary)
        let hasBeenAddedToWindow = primaryVC?.hasBeenAddedToWindow ?? false
        primaryVC?.viewDidDismissModal(viewWasOutOfWindow: !hasBeenAddedToWindow)
    }
}

extension UIViewController: ModalAwareLifecycle {
    public func viewDidDismissModal(viewWasOutOfWindow: Bool) {}
}

fileprivate extension UIViewController {
    var hasBeenAddedToWindow: Bool {
        viewIfLoaded?.window != nil
    }
}

extension UIViewController {
    static func swizzleDismiss() {
        let uikitSelector = #selector(dismiss)
        let newSelector = #selector(newDismiss)
        let oldSelector = #selector(oldDismiss)

        guard let uikitMethod = class_getInstanceMethod(self, uikitSelector),
              let newMethod = class_getInstanceMethod(self, newSelector),
              let oldMethod = class_getInstanceMethod(self, oldSelector) else {
            return
        }

        let uikitImplementation = method_getImplementation(uikitMethod)
        let newImplementation = method_getImplementation(newMethod)
        
        method_setImplementation(uikitMethod, newImplementation);
        method_setImplementation(oldMethod, uikitImplementation);
    }
    
    @objc
    private func newDismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: flag,
                completion: completion,
                superDismissRef: self.oldDismiss)
    }
    
    @objc
    private func oldDismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        //At runtime it receives the implementation of uikit dismiss
    }
}
