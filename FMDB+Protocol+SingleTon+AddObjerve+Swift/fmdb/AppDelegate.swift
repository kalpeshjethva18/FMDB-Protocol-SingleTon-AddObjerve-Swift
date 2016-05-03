//
//  AppDelegate.swift
//  fmdb
//
//  Created by macpc on 23/02/15.
//  Copyright (c) 2015 macpc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var testNavigationController: UINavigationController?
    var myViewController:viewcontroller?
    var databasePath = NSString()
    var fileName = "PizzaSystemDB.sqlite"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var mainViewController = viewcontroller(nibName: "viewcontroller", bundle: nil)
        var navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBarHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        [self.copyFile(fileName)]
        
        return true
    }
    func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName as String)
        println("copyFile fileName=\(fileName) to path=\(dbPath)")
        var fileManager = NSFileManager.defaultManager()
        var fromPath: String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName as String)
        if !fileManager.fileExistsAtPath(dbPath) {
            println("dB not found in document directory filemanager will copy this file from this path=\(fromPath) :::TO::: path=\(dbPath)")
            fileManager.copyItemAtPath(fromPath!, toPath: dbPath, error: nil)
        } else {
            println("DID-NOT copy dB file, file allready exists at path:\(dbPath)")
        }
    }
    func getPath(fileName: String) -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("PizzaSystemDB.sqlite")
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

