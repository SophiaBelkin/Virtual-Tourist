//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by sophia liu on 8/2/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let dataController = DataController(modelName:"Tourist")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dataController.load()
        // Override point for customization after application launch.
        let navigationViewController = window?.rootViewController as! UINavigationController
        let mapViewController = navigationViewController.topViewController as! MapViewController
        mapViewController.dataController = dataController

        
        return true
    }

}

