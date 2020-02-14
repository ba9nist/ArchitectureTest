//import UIKit
//public protocol RouterType: class, Presentable {
//    var navigationController: UINavigationController { get }
//    var rootViewController: UIViewController { get }
//    func present(_ module: Presentable, animated: Bool)
//    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
//    func popModule(animated: Bool)
//    func dismissModule(animated: Bool, completion: (() -> Void)?)
//    func setRootModule(_ module: Presentable, hideBar: Bool)
//    func popToRootModule(animated: Bool)
//}
//final public class Router: NSObject, RouterType, UINavigationControllerDelegate {    private var completions: [UIViewController : () -> Void]
//    public var rootViewController: UIViewController...
//    public unowned let navigationController: UINavigationController
//    public init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//        self.completions = [:]
//        super.init()
//        self.navigationController.delegate = self
//    }
//    public func toPresentable() -> UIViewController {
//        return navigationController
//    }
//    public func present(_ module: Presentable, animated: Bool) {
//        guard let controller = module.toPresentable() else {
//            return
//        }
//        navigationController.present(controller, animated: animated, completion: nil)
//    }
//    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
//        navigationController.dismiss(animated: animated, completion: completion)
//    }
//    public func push(_ module: Presentable, animated: Bool = true, completion: (() -> Void)? = nil) {        // Avoid pushing UINavigationController onto stack
//        guard let controller = module.toPresentable(),
//            controller is UINavigationController == false else {
//                return
//        }
//        if let completion = completion {
//            completions[controller] = completion
//        }
//        navigationController.pushViewController(controller, animated: animated)
//    }
//    public func popModule(animated: Bool = true)  {
//        
//        if let controller = navigationController.popViewController(animated: animated) {
//            runCompletion(for: controller)
//        }
//    }
//    public func setRootModule(_ module: Presentable, hideBar: Bool){
//        guard let controller = module.toPresentable() else {
//            return
//        }
//        navigationController.setViewControllers([controller], animated: false)
//        navigationController.isNavigationBarHidden = hideBar
//    }
//    public func popToRootModule(animated: Bool) {
//        if let controllers = navigationController.popToRootViewController(animated: animated) {
//            controllers.forEach { runCompletion(for: $0) }
//        }
//    }
//    fileprivate func runCompletion(for controller: UIViewController) {
//        guard let completion = completions[controller] else {
//            return
//        }
//        completion()
//        completions.removeValue(forKey: controller)
//    }    // MARK: UINavigationControllerDelegate
//    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        
//        // Ensure the view controller is popping
//        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(poppedViewController) else {
//            return
//        }
//        runCompletion(for: poppedViewController)
//    }
//}
