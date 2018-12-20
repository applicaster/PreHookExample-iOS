//
//  HookManager+NonScreenPlugin.swift
//  PrehookExample
//
//  Created by Anton Kononenko on 12/20/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappPlugins

extension HookManager {
    func didFailHandlerPushedNonScreen() {
        hookViewController?.removeViewFromParentViewController()
    }
    
    func didSuccessHandlerPushedNonScreen() {
        hookViewController?.removeViewFromParentViewController()
    }
    
    func executeHookNonScreenLogic() {
        let topViewController = ZAAppConnector.sharedInstance().navigationDelegate.topmostModal()
        let screenVC = createScreen()
        topViewController?.addChildViewController(screenVC, to: topViewController?.view)
        
        hookViewController?.hookManagerDelegate = self
        
        requestScreenPluginPresentation { [weak self] (allowScreenPluginPresentation) in
            if allowScreenPluginPresentation == false {
                self?.hookCompletion?(true,
                                      nil,
                                      nil)
            }
        }
    }
}
