//
//  ZLScreenModel+HookCustomization.swift
//  PrehookExample
//
//  Created by Anton Kononenko on 12/20/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappPlugins

extension ZLScreenModel {
    
    /// Return is hook plugin a flow blocker.
    /// Note: Please note that this key was added only for test cases in this example read more details in documentation
    public var isFlowBlocker:Bool {
        guard let retVal = general["is_flow_blocker"] as? Bool else {
            return false
        }
        return retVal
    }
    
    /// Return is hook plugin allow presentation.
    /// Note: Please note that this key was added only for test cases in this example read more details in documentation
    public var allowScreenPluginPresentation:Bool {
        guard let retVal = general["allow_screen_plugin_presentation"] as? Bool else {
            return false
        }
        return retVal
    }
}
