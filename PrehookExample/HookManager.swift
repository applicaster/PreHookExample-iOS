//
//  HookManager.swift
//  PrehookTest
//
//  Created by Anton Kononenko on 10/22/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

enum HookManagerTypes {
    case screen
    case nonScreen
}

import Foundation
import ZappPlugins
public typealias HookCompletion = (Bool, NSError?) -> Void

protocol HookManagerDelegate {
    func didSuccessHandlerPushed()
    func didFailHandlerPushed()
}

public class HookManager: NSObject, ZPScreenHookProtocol, HookManagerDelegate {
    struct Keys {
        static let isScreenPluginKey = "screen"
    }
    var pluginModel:ZPPluginModel
    var screenModel:ZLScreenModel?
    var dataSourceModel:NSObject?
    var type:HookManagerTypes = .nonScreen
    var hookViewController:HookScreenViewController?
    
    var hookCompletion:HookCompletion?
    func didSuccessHandlerPushed() {
        if type == .nonScreen {
            hookViewController?.removeViewFromParentViewController()
        } else if type == .screen,
                let presentation = screenModel?.style?.object["presentation"] as? String,
                presentation == "present"{
                
            _ = ZAAppConnector.sharedInstance().genericDelegate.closeViewControllerCreatedFromNavigationBar(viewController: ZAAppConnector.sharedInstance().navigationDelegate.topmostModal())
        }
        hookCompletion?(true, nil)
    }
    func didFailHandlerPushed() {
   
        if type == .nonScreen {
            UIView.animate(withDuration: 0.5, animations: {  [weak self] in
                self?.hookViewController?.view.alpha = 0
            }) {  [weak self] (success) in
                self?.hookViewController?.removeViewFromParentViewController()
            }
        } else if type == .screen,
            let presentation = screenModel?.style?.object["presentation"] as? String,
            presentation == "present"{
            
            _ = ZAAppConnector.sharedInstance().genericDelegate.closeViewControllerCreatedFromNavigationBar(viewController: ZAAppConnector.sharedInstance().navigationDelegate.topmostModal())
            
        }
        let error = NSError(domain: "In hook somethin failed",
                            code: 0,
                            userInfo: nil)
        hookCompletion?(false, error)

    }
    required public init?(pluginModel:ZPPluginModel,
          dataSourceModel:NSObject?) {
        self.pluginModel = pluginModel
        self.dataSourceModel = dataSourceModel
    }
    public required init?(pluginModel: ZPPluginModel,
                          screenModel: ZLScreenModel,
                          dataSourceModel: NSObject?) {
        self.pluginModel = pluginModel
        self.screenModel = screenModel
        self.dataSourceModel = dataSourceModel
        if self.screenModel?.isPluginScreen() == true {
            type = .screen
        }
    }
    
    public func executeHook(presentationIndex: NSInteger,
                            taskFinishedWithCompletion: @escaping (Bool, NSError?) -> Void) {
        hookCompletion = taskFinishedWithCompletion

        if type == .nonScreen {
            let topViewController = ZAAppConnector.sharedInstance().navigationDelegate.topmostModal()
            let screenVC = createScreen()
            topViewController?.addChildViewController(screenVC, to: topViewController?.view)
            screenVC.view.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                screenVC.view.alpha = 1
            }, completion: nil)
        }
        hookViewController?.hookManagerDelegate = self

    }
    
    @objc public var isFlowBlocker:Bool {
        return true
    }
    
    @objc public func requestScreenPluginPresentation(completion:@escaping (_ allowScreenPluginPresentation:Bool) -> Void) {
        completion(true)
    }
    
    @objc public func reccuringPostLaunchHook( completion: @escaping (_ isReccurring:Bool) -> Void) {
        completion(true)
    }

    @objc public func hookPluginDidDisappear(viewController:UIViewController) {
        let error = NSError(domain: "User has closed hook execution failed", code: 0, userInfo: nil)
    
        hookCompletion?(false, error)
        
        
    }
    
    lazy var bundle = Bundle(for: HookManager.self)
}

extension HookManager: ZPPluggableScreenProtocol {
    @objc public func createScreen() -> UIViewController {
        hookViewController = HookScreenViewController(nibName: "HookScreenViewController",
                                                      bundle:bundle)
        hookViewController?.pluginModel = pluginModel
        hookViewController?.screenModel = screenModel
        hookViewController?.dataSourceModel = dataSourceModel
        
        return hookViewController!
    }
}
