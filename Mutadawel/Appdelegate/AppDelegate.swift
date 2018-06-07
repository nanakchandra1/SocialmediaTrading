//
//  AppDelegate.swift
//  Mutadawel
//
//  Created by Appinventiv on 05/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Fabric
import Crashlytics
import FirebaseCore
import FirebaseMessaging


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate ,MessagingDelegate {

    var window: UIWindow?
    var nvc: UINavigationController!
    var appLanguage = AppLanguage.Arabic
    var pushData: PushPayLoad?
    var deviceToken: String?
	var notiCount :Int = 0
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
//        if url.host != nil {
//           let encodedHost = url.host
//
//            guard let decodedData = Data.init(base64Encoded: encodedHost!) else { return true }
//            guard let decodedString = String.init(data: decodedData, encoding: .utf8) else { return true }
//
//
//            let obj = homeStoryboard.instantiateViewController(withIdentifier: "HomeID") as! HomeVC
//
//            sharedAppdelegate.nvc.pushViewController(obj, animated: true)
//
//        }

        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
        // Override point for customization after application launch.
		
        self.setInitialViewController()
        Fabric.with([Crashlytics.self])
		
		ACTAutomatedUsageTracker.enableAutomatedUsageReporting(withConversionID: "833619975")
		ACTConversionReporter.report(withConversionID: "833619975", label: "9X7FCJqepnUQh5DAjQM", value: "3.00", isRepeatable: false)
		
        UIApplication.shared.applicationIconBadgeNumber = CurrentUser.notification_count_for_bage! + CurrentUser.chat_notification_count_for_bage!
		
        Messaging.messaging().delegate = self
        
        RegisterForPushNotification()
		FirebaseApp.configure()
        return true
    }

    
	func RegisterForPushNotification() {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let center = UNUserNotificationCenter.current()
			//center.delegate = self as? UNUserNotificationCenterDelegate
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                print_debug(object: "Permission granted: \(granted)")
                
				guard granted else { return }
                self.getNotificationSettings()
            }
            //UIApplication.shared.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.sound,UIUserNotificationType.alert,UIUserNotificationType.badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
			UIApplication.shared.registerForRemoteNotifications()
            self.getNotificationSettings()
        }
    }

	func getNotificationSettings() {
		
		if #available(iOS 10.0, *) {
			UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print_debug(object: "Notification settings: \(settings)")
				guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
			}
		} else {
			// Fallback on earlier versions
		}
	}
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
    
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) -> Void
    {
//        let characterSet: CharacterSet = CharacterSet( charactersIn: "<>" )
//        var token = ""
//        for i in 0..<deviceToken.count {
//            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
//        }
//
//        token = token.trimmingCharacters(in: characterSet)
//        token = token.replacingOccurrences(of: " ", with: "")
		let tokenParts = deviceToken.map { data -> String in
			return String(format: "%02.2hhx", data)
		}
		
		let token = tokenParts.joined()
        print_debug(object: "Device Token: \(token)")
		
        if !token.isEmpty
        {
            self.deviceToken = token
			
        }else{
			
            self.deviceToken = "123456"
        }
    }
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		
        print_debug(object: "####ERROR:\(error)")
		
	}
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

        //self.launchedFromPushNotification = true
        self.getNotification(application, userInfo: userInfo)

    }
	
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let aps = (userInfo as? [String: AnyObject]) else { return }
        
        guard let info = aps["aps"] as? [String : AnyObject] else { return }
        
        guard let type = info["type"] else{return}
        
        if application.applicationState == .background{
            
        if "\(type)" == "admin_chat" || "\(type)" == "chat"{
			
			
            self.chatNotificationCount()
			
        }else{
            
            self.notificationCount()
            
            }
        }else if application.applicationState == .active{
            
            
                if "\(type)" == "admin_chat" || "\(type)" == "chat"{
                    
                    self.chatNotificationCount()
					
                }else{
                    
                    self.notificationCount()
                    
                }
        }
        
        self.pushData = PushPayLoad(withPayLoad: info)
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        XMPPhelper.sharedInstance().goOffline()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        

        if CurrentUser.user_id != nil{
            XMPPhelper.sharedInstance().goOnline()
        }
        
        //UIApplication.shared.applicationIconBadgeNumber = 0

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        if CurrentUser.user_id != nil{
            XMPPhelper.sharedInstance().goOffline()
        }
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Mutadawel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
	}()

    // MARK: - Core Data Saving support

    func saveContext () {
        if #available(iOS 10.0, *){
            let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        } else {
            // Fallback on earlier versions
        }

    }

}

extension AppDelegate{
    
    func setupAmazonS3() {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.usWest2,
                                                                identityPoolId:"us-west-2:4c58fa05-1824-4a22-a5be-667cede1861c")
        let configuration = AWSServiceConfiguration(region:.usWest2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
    }
    
	
    func setInitialViewController(){
        XMPPhelper.sharedInstance().setupStream()
        XMPPhelper.sharedInstance().userPassword = "123456"
        self.setupAmazonS3()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
		
		
        guard let language = CurrentUser.app_language , !language.isEmpty else{
            
            userDefaults.set("ar", forKey: UserDefaultsKeys.APP_LANGUAGE)
            self.appLanguage = .Arabic
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            goToLoginOption()
            return
        }
        
        if language == "en"{
            self.appLanguage = .English
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }else{
            self.appLanguage = .Arabic
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        if CurrentUser.user_id != nil{
			
          //TODO: =======AUTO_LOGIN========
			var params = JSONDictionary()
			params["userId"] = CurrentUser.user_id! 
			params["platform"] = "2"
			
			autoLoginAPI(params: params, webServiceSuccess: { (success, msg, data) in
				
				if success{
					
				}else{
					
				}
			})
			
            gotoHome()
            
        }else{
            
            goToLoginOption()
        }
    }
    
    
    func getNotification(_ application: UIApplication,  userInfo: [AnyHashable : Any]){
    
        
        guard let aps = (userInfo as? [String: AnyObject]) else { return }
        
        guard let info = aps["aps"] as? [String : AnyObject] else { return }
        
        
        if application.applicationState == .background || application.applicationState == .inactive{
            
            self.handlePush(application: application, userInfo: aps as [NSObject : AnyObject])
            //self.notificationCount()
        }
        
        self.pushData = PushPayLoad(withPayLoad: info)

    }
    
    func chatNotificationCount(){
        
        if CurrentUser.chat_notification_count != nil{
            
            var count = Int(CurrentUser.chat_notification_count!)
            count = count! + 1
            userDefaults.set("\(count!)", forKey: UserDefaultsKeys.chat_notification_count)
            NotificationCenter.default.post(name: .myNotificationKey, object: nil, userInfo: ["type":"chat"])
            
        }else{
            userDefaults.set("\(1)", forKey: UserDefaultsKeys.chat_notification_count)
            NotificationCenter.default.post(name: .myNotificationKey, object: nil, userInfo: ["type":"chat"])
        }
    
    }

    
    func notificationCount(){
        
        if CurrentUser.notification_count != nil{
            
            var count = Int(CurrentUser.notification_count!)
            count = count! + 1
            userDefaults.set("\(count!)", forKey: UserDefaultsKeys.notification_count)
            NotificationCenter.default.post(name: .myNotificationKey, object: nil, userInfo: ["type":"normal"])
            
        }else{
            userDefaults.set("\(1)", forKey: UserDefaultsKeys.notification_count)
            NotificationCenter.default.post(name: .myNotificationKey, object: nil, userInfo: ["type":"normal"])
        }

    }
    
    
    func handlePush(application: UIApplication,  userInfo: [NSObject: AnyObject]){
        
        guard let info = userInfo as? [String : AnyObject] else { return }

        
        guard let aps = info["aps"] as? [String : AnyObject] else { return }


        print_debug(object: info)
        
        guard let type = aps["type"]  else{return}
        
        if "\(type)" == "admin_chat"{
            
            gotoMessageVC(chatInfo: aps, isAdmin: true)
			self.chatNotificationCount()
			
        }else if "\(type)" == "chat"{
            
            gotoMessageVC(chatInfo: aps, isAdmin: false)
			self.chatNotificationCount()
			
        }else{
            
           // self.notificationCount()
            
            if let postId = aps["post_id"]{
                
                if "\(postId)" == "0"{
                    
                    gotoNotification(false, aps: aps)
                    
                }else{
                    
                    gotoNotification(true, aps: aps)
					self.notificationCount()
                }
            }
        }
    }
}


struct PushPayLoad {
    
    let alert:String!
    let user_token:String!
    let product_token:String!
    let data:[String:AnyObject]!
    let pushId : Int!
    let roleID:String!
    let postID:String!
    
    init(withPayLoad : [String : AnyObject]) {
        
        self.data = withPayLoad
        self.pushId = 0
        self.alert = withPayLoad["alert"] as? String ?? ""
        self.user_token = withPayLoad["user_token"] as? String ?? ""
        self.product_token = withPayLoad["product_token"] as? String ?? ""
        self.roleID = withPayLoad["role_id"] as? String ?? ""
        self.postID = withPayLoad["post_id"] as? String ?? ""
    }
}
