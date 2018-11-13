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

public typealias HookCompletion = (Bool, NSError?, [String : Any]?) -> Void

protocol HookManagerDelegate {
    func didSuccessHandlerPushed()
    func didFailHandlerPushed()
}

public class HookManager: NSObject, ZPScreenHookAdapterProtocol, HookManagerDelegate {
    public var screenPluginDelegate: ZPPlugableScreenDelegate?

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
        hookCompletion?(true, nil, nil)

        if type == .nonScreen {
            hookViewController?.removeViewFromParentViewController()
        } else if type == .screen,
                let presentation = screenModel?.style?.object["presentation"] as? String,
                presentation == "present" {
                screenPluginDelegate?.removeScreenPluginFromScreen()
        } else if type == .screen {
            screenPluginDelegate?.removeScreenPluginFromNavigationStack()
        }
    }
    
    func didFailHandlerPushed() {
   
        if type == .nonScreen {
            hookViewController?.removeViewFromParentViewController()

        } else if type == .screen,
            let presentation = screenModel?.style?.object["presentation"] as? String,
            presentation == "present" {
            screenPluginDelegate?.removeScreenPluginFromScreen()
            
        } else if type == .screen {
            
            //call it only fot poping
            if isFlowBlocker == true {
                screenPluginDelegate?.removeScreenPluginFromScreen()
            }
        }
        let error = NSError(domain: "In hook something failed",
                            code: 0,
                            userInfo: nil)
        hookCompletion?(false, error, nil)

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
                            dataDict:[String:Any]?,
                            taskFinishedWithCompletion: @escaping (Bool, NSError?, [String : Any]?) -> Void) {
        hookCompletion = taskFinishedWithCompletion

        if type == .nonScreen {
            let topViewController = ZAAppConnector.sharedInstance().navigationDelegate.topmostModal()
            let screenVC = createScreen()
            topViewController?.addChildViewController(screenVC, to: topViewController?.view)
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
        hookCompletion?(false, error, nil)
    }
    
    lazy var bundle = Bundle(for: HookManager.self)
}

extension HookManager: ZPPluggableScreenProtocol {
    @objc public var customTitle:String? {
        return "Test Custom Title"
    }
    
    @objc public func createScreen() -> UIViewController {
        hookViewController = HookScreenViewController(nibName: "HookScreenViewController",
                                                      bundle:bundle)
        hookViewController?.pluginModel = pluginModel
        hookViewController?.screenModel = screenModel
        hookViewController?.dataSourceModel = dataSourceModel
        
        return hookViewController!
    }
}
