//
//  AppDelegate.swift
//  medbuddyapp
//
//  Created by Admin User on 4/3/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit

import KCFloatingActionButton
import RSFloatInputView
import Alamofire
import ObjectMapper
import UserNotifications
import UserNotificationsUI
import SwiftyJSON
import RESideMenu
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,RESideMenuDelegate {

    var window: UIWindow?
    var updateTimer: Timer?
    let requestIdentifier = "SampleRequest"
    
    
    let visitlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"visittableviewcontroller") as! VisitTableViewController
    
    let alertlistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"alertlistcontroller") as! AlertTableViewController
    
    let messagelistController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"messagelistcontroller") as! MessageTableViewController
    

    var leftMenuViewController = DEMOLeftMenuViewController()
    var rightMenuViewController = DEMORightMenuViewController()
    var navigationController = UIStoryboard(name:"Main",bundle:nil).instantiateViewController(withIdentifier:"mainNavController") as! UINavigationController
    var sideMenuController : RESideMenu!
    var m_VisitfabButton : KCFABManager?
    var m_AlertfabButton : KCFABManager?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) ->
        Bool {
            navigationController.setViewControllers([visitlistController], animated: true)
            m_VisitfabButton = KCFABManager.defaultInstance();
            m_VisitfabButton?.getButton().addItem("Create New Visit", icon: nil, handler: { item in
                let alert = UIAlertController(title: "Create", message: "Create New Visit", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.visitlistController.createNewVisit()
                }))
                self.visitlistController.present(alert, animated: true, completion: nil)
                self.m_VisitfabButton?.getButton().close()
            })
            RSFloatInputView.stringTransformer = {
                orginal in
                // Transform the place holder string configured in XIB with your own way.
                // e.g return NSLocalizedString(orginal, comment: orginal)
                return orginal.replacingOccurrences(of: "TXT_", with: "")
            }
            RSFloatInputView.instanceTransformer = {
                instance in
                // Support multi-styles in one place using the tag
                if instance.tag == 0 {
                    instance.floatPlaceHolderColor = UIColor.brown
                    instance.textColor = UIColor.darkText
                    instance.tintColor = UIColor.brown
                }
            }
            
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            
            return true
    }


    func setupCustomWindow() {
        
        let sideMenuController = RESideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
        sideMenuController?.panGestureEnabled = false
        sideMenuController?.backgroundImage = UIImage(named : "Stars")
        sideMenuController?.menuPreferredStatusBarStyle = .lightContent; // UIStatusBarStyleLightContent
        sideMenuController?.delegate = self;
        sideMenuController?.contentViewShadowColor = UIColor.black
        sideMenuController?.contentViewShadowOffset = CGSize(width: 0, height: 0)
        sideMenuController?.contentViewShadowOpacity = 0.6;
        sideMenuController?.contentViewShadowRadius = 12;
        sideMenuController?.contentViewShadowEnabled = true;
        self.window?.rootViewController = sideMenuController;
        
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        getUserDetail()
    }
    
    func getUserDetail(){
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        
        Alamofire.request("\(APIInterface.UserManagementURL)/\(Database.email!)", method: .get, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")  
                print("HttpURL Response:\(response.response)")
                print("Server Data:\(response.result.value)")
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        Database.User = Mapper<User>().map(JSONString: response.result.value!)!
                        //Database.User = Mapper<User>().map(JSONObject: response.result.value)
                        
                    }
                    else{
                    }
                    
                }
        }

    }
    func runNotificationTimer(){
        //updateTimer = Timer.scheduledTimer(timeInterval: 10, target: self,
        //                                       selector: #selector(fetchData), userInfo: nil, repeats: true)
    }
    func fetchData(){
        let headers = ["Content-Type" : "application/json;charset=UTF-8", "Authorization" : "Bearer "+Database.token!]
        
        Alamofire.request("\(APIInterface.UserManagementURL)/\(Database.email!)/status", method: .get, headers: headers)
            .responseString{ response in
                print("HttpURL Request:\(response.request)")  // original URL request
                print("HttpURL Response:\(response.response)") // HTTP URL response
                print("Server Data:\(response.result.value)")     // Token data
                if (response.result.isSuccess){
                    let statusCode = response.response?.statusCode
                    if (statusCode! >= 200 && statusCode! < 300){
                        let tempStatus = Mapper<UserStatus>().map(JSONString: response.result.value!)
                        if (Database.userStatus.isEqual(status: tempStatus!) == true){
                            /*Database.userStatus = tempStatus
                            Database.userStatus.numOfUnreadMails = 1 + Database.userStatus.numOfUnreadMails
                            self.triggerNotification()
                            self.visitlistController.updateScreen()*/
                        }
                        else{
                            Database.userStatus = tempStatus
                            self.triggerNotification()
                            self.visitlistController.updateScreen()
                        }
                    }
                    else{
                    }
                    
                }
        }
    }
    func triggerNotification(){
        
        print("notification will be triggered in five seconds..Hold on tight")
        let content = UNMutableNotificationContent()
        content.title = "Intro to Notifications"
        content.subtitle = "Lets code,Talk is cheap"
        content.body = "Sample code from WWDC"
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "monkey", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("attachment not found.")
            }
        }
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        // Start the long-running task and return immediately.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    }

}
extension AppDelegate:UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}


