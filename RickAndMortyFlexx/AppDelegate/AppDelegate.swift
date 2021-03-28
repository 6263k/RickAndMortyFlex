//
//  AppDelegate.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
    let dependecies = AppAssembly.assembly()
    
    return true
  }



}

