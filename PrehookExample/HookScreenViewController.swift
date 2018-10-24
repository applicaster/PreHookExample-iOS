//
//  HookScreenViewController.swift
//  PrehookTest
//
//  Created by Anton Kononenko on 10/22/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import UIKit
import ZappPlugins

class HookScreenViewController:UIViewController {
    struct Keys {
        static let titleKey = "title"
        static let nameKey = "name"
    }
    public var pluginModel:ZPPluginModel?
    public var screenModel:ZLScreenModel?
    public var dataSourceModel:NSObject?
    
    var hookManagerDelegate:HookManagerDelegate?
    @IBOutlet weak var dataSourceLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = dataSourceTitle
        dataSourceLabel.text = dataSourceTitle
        
    }
    @IBAction func successAction(_ sender: UIButton) {
        hookManagerDelegate?.didSuccessHandlerPushed()
    }
    
    @IBAction func failedAction(_ sender: UIButton) {
        
        let currentViewController = self.navigationController?.visibleViewController
        hookManagerDelegate?.didFailHandlerPushed()
        
        //call it only fot poping
//        if let viewControllers = self.navigationController?.viewControllers {
//            let newViewControllers = viewControllers.filter { $0 != currentViewController }
//            self.navigationController?.viewControllers = newViewControllers
//        }
    }
    
    var dataSourceTitle:String {
        var retVal = ""
        if let dataSourceModel = dataSourceModel,
            let dict = ZAAppConnector.sharedInstance().genericDelegate.datasourceModelDictionary(withModel: dataSourceModel) {
            if let title = dict[Keys.titleKey] as? String {
                retVal = title
            } else if let name = dict[Keys.nameKey] as? String {
                retVal = name
            }
        }
        return retVal
    }
}
