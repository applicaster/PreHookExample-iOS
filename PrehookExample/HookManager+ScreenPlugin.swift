//
//  HookManager+ScreenPlugin.swift
//  PrehookExample
//
//  Created by Anton Kononenko on 12/20/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation

extension HookManager {
    
    func didFailHandlerPushedScreen() {
        // We want to remove from stack only if not flow-blocker
        if isFlowBlocker == false {
            screenPluginDelegate?.removeScreenPluginFromNavigationStack()
        }
    }
    func didSuccessHandlerPushedScreen() {
        screenPluginDelegate?.removeScreenPluginFromNavigationStack()
    }
    
    func executeHookScreenLogic() {
        hookViewController?.hookManagerDelegate = self
    }
}
