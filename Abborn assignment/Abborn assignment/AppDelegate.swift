//
//  AppDelegate.swift
//  Abborn assignment
//
//  Created by Michal  on 24/10/2020.
//

import UIKit
import RealmSwift

func bundlePath(path: String) -> String? {
    let resourcePath = Bundle.main.resourcePath as NSString?
    return resourcePath?.appendingPathComponent(path)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func openRealm() {
        let defaultPath = Realm.Configuration.defaultConfiguration.fileURL?.path
        if let v0Path = bundlePath(path: "default.realm") {
            if FileManager.default.fileExists(atPath: defaultPath!) {
                do {
                    try FileManager.default.removeItem(atPath:defaultPath!)
                    print("Remove old file")
                } catch {
                    print("Wasn't removed")
                }
            }
            do {
                try FileManager.default.copyItem(atPath: v0Path, toPath: defaultPath!)
                print("Copied.")
            } catch {
                print("Wasn't copied.")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // print(Realm.Configuration.defaultConfiguration.fileURL?.path)
        openRealm()
        
        _ = try! Realm()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

