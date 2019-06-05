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

/// Delegate notify manager from screen plugin view controller
protocol HookManagerDelegate {
    func didSuccessHandlerPushed()
    func didFailHandlerPushed()
}


/// This manager shows simple example usage of the Native Hook
public class HookManager: NSObject, ZPScreenHookAdapterProtocol {
    public var screenPluginDelegate: ZPPlugableScreenDelegate?
    lazy var bundle = Bundle(for: HookManager.self)

    struct Keys {
        static let isScreenPluginKey = "screen"
    }
    var pluginModel:ZPPluginModel
    var screenModel:ZLScreenModel?
    var dataSourceModel:NSObject?
    var type:HookManagerTypes = .nonScreen
    var hookViewController:HookScreenViewController!
    
    var hookCompletion:HookCompletion?

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
            executeHookNonScreenLogic()
        } else {
            executeHookScreenLogic()
        }
    }
    
    @objc public var isFlowBlocker:Bool {
        return self.screenModel?.isFlowBlocker ?? false
    }
    
    @objc public func requestScreenPluginPresentation(completion:@escaping (_ allowScreenPluginPresentation:Bool) -> Void) {
        completion(self.screenModel?.allowScreenPluginPresentation ?? true)
    }
    
    @objc public func hookPluginDidDisappear(viewController:UIViewController) {
        let error = NSError(domain: "User has closed hook execution failed", code: 0, userInfo: nil)
        hookCompletion?(false,
                        error,
                        nil)
    }
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
        hookViewController?.hookManagerDelegate = self

        return hookViewController!
    }
}

extension HookManager: HookManagerDelegate {
    func didSuccessHandlerPushed() {
        hookCompletion?(true, nil, nil)
        
        if type == .nonScreen {
            didSuccessHandlerPushedNonScreen()
        } else if type == .screen {
            didSuccessHandlerPushedScreen()
        }
    }
    
    func didFailHandlerPushed() {
        let error = NSError(domain: "In hook something failed",
                            code: 0,
                            userInfo: nil)
        hookCompletion?(false, error, nil)
        
        if type == .nonScreen {
            didFailHandlerPushedNonScreen()
        } else if type == .screen {
            didFailHandlerPushedScreen()
        }
    }
}
