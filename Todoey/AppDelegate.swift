//
//  AppDelegate.swift
//  Todoey
//
//  Created by Nived Pradeep on 22/11/18.
//  Copyright © 2018 Nived Pradeep. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
   class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        }
        catch{
            print(error)
        }
        
        
        return true
    }

    
}
    
    


