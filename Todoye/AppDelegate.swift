//
//  AppDelegate.swift
//  Todoye
//
//  Created by Zabeehullah Qayumi on 9/2/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Printtin out the Realm file path location
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
      
        
//        let data = Data()
//        data.name = "Zabeeh"
//        data.age = 10
//        
        do{
            _ = try Realm()
            
//            try realm.write {
//                realm.add(data)
//            }
        }catch{
            print("Error initialising new realm, \(error)")
        }
        
        
        
        return true
    }
   

}

