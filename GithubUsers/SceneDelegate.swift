//
//  SceneDelegate.swift
//  GithubUsers
//
//  Created by José Lucas Souza das Chagas on 12/04/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let usersNavController = UINavigationController(rootViewController: ListUsersVCFactory.make())
        usersNavController.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let searchUsersNavController = UINavigationController(rootViewController: SearchUsersVCFactory.make())
        searchUsersNavController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let tabController = UITabBarController()
        tabController.viewControllers = [
            usersNavController,
            searchUsersNavController
        ]
        
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

@objc
public protocol ModalAwareLifeCycle: AnyObject {
    func viewDidDismissModal(viewWasOutOfWindow: Bool)
}

fileprivate extension ModalAwareLifeCycle where Self: UIViewController {
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

extension UIViewController {
    var hasBeenAddedToWindow: Bool {
        viewIfLoaded?.window != nil
    }
}

extension UIViewController: ModalAwareLifeCycle {
    public func viewDidDismissModal(viewWasOutOfWindow: Bool) {}
}

extension UINavigationController {
    public override func viewDidDismissModal(viewWasOutOfWindow: Bool) {
        topViewController?.viewDidDismissModal(viewWasOutOfWindow: viewWasOutOfWindow)
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: flag,
                completion: completion,
                superDismissRef: super.dismiss)
    }
}

extension UITabBarController {
    public override func viewDidDismissModal(viewWasOutOfWindow: Bool) {
        selectedViewController?.viewDidDismissModal(viewWasOutOfWindow: viewWasOutOfWindow)
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: flag,
                completion: completion,
                superDismissRef: super.dismiss)
    }
}

extension UISplitViewController {
    public override func viewDidDismissModal(viewWasOutOfWindow: Bool) {
        let primaryVC = viewController(for: .primary)
        let hasBeenAddedToWindow = primaryVC?.hasBeenAddedToWindow ?? false
        primaryVC?.viewDidDismissModal(viewWasOutOfWindow: !hasBeenAddedToWindow)
        fatalError("Validation needed")
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: flag,
                completion: completion,
                superDismissRef: super.dismiss)
    }
}

public class ViewController: UIViewController {
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: flag,
                completion: completion,
                superDismissRef: super.dismiss)
    }
}
