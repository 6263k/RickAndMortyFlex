//
//  AppDelegate.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var appCoordinator: AppCoordinator?
  var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let dependecies = AppAssembly.assembly()
    appCoordinator = AppCoordinator(with: window, dependecies: dependecies)
    appCoordinator?.start()
    return true
  }



}

