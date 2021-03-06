//
//  AppDelegate.swift
//  SampleRxSwift
//
//  Created by Jeans Ruiz on 2/17/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

// MARK: - For use request without https, modify
// info.plist
// App Transport Security Settings
// Allow Arbitrary Loads  == YES

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let mainVC = MainViewController(viewModel: MainViewModel() )
    let navigationBar = UINavigationController(rootViewController: mainVC)
    
    mainVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    
    let mainTabBar = UITabBarController()
    mainTabBar.viewControllers = [navigationBar]
    
    window?.rootViewController = mainTabBar
    window?.makeKeyAndVisible()
    return true
  }
  
}
