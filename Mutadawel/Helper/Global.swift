//
//  Global.swift
//  Mutadawel
//
//  Created by Appinventiv on 07/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAnalytics
import SwiftyJSON


typealias JSONDictionary = [String:Any]
typealias StringDictionary = [String:String]
typealias JSONDictionaryArray = [JSONDictionary]
typealias JSONArray = [JSON]

let APPSTORE_URL = "https://itunes.apple.com/us/app/tridder/id1241370608?ls=1&mt=8"

enum AppLanguage: String {
    
    case English = "en"
    case Arabic = "ar"
}


let activityPlaceholder = UIImage(named: "placeholder")
let ImagePlaceHolder = UIImage(named: "ic_profile_placeholder")


struct PostStatusImages{

    static let right_tick = UIImage(named: "ic_tick_")
    static let watch = UIImage(named: "ic_time_")
    static let cross = UIImage(named: "ic_cross_")
    //static let right_tick = UIImage(named: "ic_tick_")
}

enum lastVisitedScreen : String {
    
    case market,stock,currency
}

//MARK:StoryBoard Initialization
enum AppStoryboard : String{
    
    case Main = "Main"
    case PreLogin = "PreLogin"
    case Settings = "Settings"
    case SideMenu = "SideMenu"
    case Home = "Home"
    case PostDetails = "PostDetails"
    case ChatView = "ChatView"


    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}


let mainStoryboard = AppStoryboard.Main.instance
let preLoginStoryboard = AppStoryboard.PreLogin.instance
let settingsStoryboard = AppStoryboard.Settings.instance
let sideMenuStoryboard = AppStoryboard.SideMenu.instance
let homeStoryboard = AppStoryboard.Home.instance
let postDetailStoryboard = AppStoryboard.PostDetails.instance


// MARK:- Main Screen Size
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenSize = UIScreen.main.bounds.size

// MARK: AppDelegate
let sharedAppdelegate = (UIApplication.shared.delegate as! AppDelegate)


func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

func setNavigationTitleFont() -> UIFont{
    return UIFont.init(name: AppFont.RobotoCondenseMed, size: 15)!
}


func displayShareSheet(shareContent:String, viewController: UIViewController) {
    
    let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = viewController.view
    viewController.present(activityViewController, animated: true, completion: nil)
    
}

func imageDisplayShareSheet(shareContent: UIImage,viewController: UIViewController) {
	
	let activityViewController = UIActivityViewController(activityItems: [shareContent as UIImage], applicationActivities: nil)
	activityViewController.popoverPresentationController?.sourceView = viewController.view
	viewController.present(activityViewController, animated: true, completion: nil)
	
}


func print_debug <T> (object: T) {
    
//    print(object)
    
}


func cleaeUserDefault(){
    
    guard let language = CurrentUser.app_language , !language.isEmpty else{
        
        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        userDefaults.synchronize()

                return
    }

    userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    userDefaults.synchronize()
    
    if language == "en"{
        sharedAppdelegate.appLanguage = .English

        userDefaults.set("en", forKey: UserDefaultsKeys.APP_LANGUAGE)

    }else{
        userDefaults.set("ar", forKey: UserDefaultsKeys.APP_LANGUAGE)
        sharedAppdelegate.appLanguage = .Arabic
    }
}


//MARK:- Validations

func isValidEmail(testStr:String) -> Bool {
    
    do {
        let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: testStr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, testStr.count)) != nil
    } catch {
        return false
    }
}


func isValidateUsername(str: String) -> Bool
    {
        do
        {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9]{5,18}$", options: .caseInsensitive)
            if regex.matches(in: str, options: [], range: NSMakeRange(0, str.count)).count > 0 {return true}
        }
        catch {}
        return false
        
}


func isValidatePhone(str: String) -> Bool{

    do
    {
        let regex = try NSRegularExpression(pattern: "[0123456789]{10,10}", options: .caseInsensitive)
        return regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count)) != nil
        
    } catch {
        
        return false
        
    }
    
}


func isValidNumber(str: String) -> Bool{
    
    do
    {
        let regex = try NSRegularExpression(pattern: "^[٠-٩]+$", options: .caseInsensitive)
        return regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count)) != nil
        
    } catch {
        
        return false
        
    }
    
}


func postLogoutNavigate(){
    
    cleaeUserDefault()
    goToLoginOption()

}

//MARK: Show/Hide loader
func showLoader(){
    Loader.showLoader()
}
func hideLoader(){
    Loader.hideLoader()
    
}

//MARK:- ===========================
//MARK:- ShowToast

func showToastWithMessage(msg: String){
    sharedAppdelegate.nvc.view.makeToast(msg)
}


//MARK:- ===========================
//MARK:- Goto viewcontrollers


func gotoHome(){
    
    // create viewController code...
    chatSetup()
    
    if sharedAppdelegate.appLanguage == .English{
        let leftMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeID") as! HomeVC
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let leftslideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        leftslideMenuController.mainViewController = sharedAppdelegate.nvc
        leftslideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = leftslideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
        
    }else{
        let rightMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeID") as! HomeVC
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let rightSideMenuController = SlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        rightSideMenuController.mainViewController = sharedAppdelegate.nvc
        rightSideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = rightSideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
    }

}



func gotoNotification(_ isPush: Bool, aps: JSONDictionary?){
    
    // create viewController code...
    chatSetup()
    
    if sharedAppdelegate.appLanguage == .English{
        let leftMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "NotificationID") as! NotificationVC
        mainViewController.isPush = isPush
        
        if aps != nil{
            
            mainViewController.postDetail = aps!

        }
        
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let leftslideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        leftslideMenuController.mainViewController = sharedAppdelegate.nvc
        leftslideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = leftslideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
        
    }else{
        
        let rightMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "NotificationID") as! NotificationVC
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        
        mainViewController.isPush = isPush

        if aps != nil{
            
            mainViewController.postDetail = aps!
            
        }

        let rightSideMenuController = SlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        rightSideMenuController.mainViewController = sharedAppdelegate.nvc
        rightSideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = rightSideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
        
    }
    
}


func gotoTrade(stockInfo : MyStockListModel){
    
    // create viewController code...
    
    if sharedAppdelegate.appLanguage == .English{
        let leftMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeID") as! HomeVC
        mainViewController.intialMode = .trade
        mainViewController.stockInfo = stockInfo
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let leftslideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        leftslideMenuController.mainViewController = sharedAppdelegate.nvc
        leftslideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = leftslideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
        
    }else{
        let rightMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeID") as! HomeVC
        mainViewController.intialMode = .trade
        mainViewController.stockInfo = stockInfo
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let rightSideMenuController = SlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        rightSideMenuController.mainViewController = sharedAppdelegate.nvc
        rightSideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = rightSideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
    }
    
}


func gotoFromSideMenu(mainViewController: UIViewController){
    
    if sharedAppdelegate.appLanguage == .English{
        
        let leftMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let leftslideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        leftslideMenuController.mainViewController = sharedAppdelegate.nvc
        leftslideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = leftslideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
        
    }else{
        
        let rightMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let rightSideMenuController = SlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        rightSideMenuController.mainViewController = sharedAppdelegate.nvc
        rightSideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = rightSideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
    }

    
}

func currentUserId() -> Int {
    let id = Int(CurrentUser.user_id!)
    return id ?? 0
}

 func goToLoginOption(){
    
    let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginSignUpOptionID") as! LoginSignUpOptionVC
    sharedAppdelegate.nvc = UINavigationController(rootViewController: vc)
    sharedAppdelegate.nvc.isNavigationBarHidden = true
    sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
    sharedAppdelegate.window?.rootViewController = sharedAppdelegate.nvc
    
}


func gotoSettings(){
    
    // create viewController code...
    if sharedAppdelegate.appLanguage == .English{
        let leftMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsID") as! SettingsVC
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let leftslideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        leftslideMenuController.mainViewController = sharedAppdelegate.nvc
        leftslideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = leftslideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()

    }else{
        let rightMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsID") as! SettingsVC
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let rightSideMenuController = SlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        rightSideMenuController.mainViewController = sharedAppdelegate.nvc
        rightSideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = rightSideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()

    }
    
}




func gotoMessageVC(chatInfo: JSONDictionary, isAdmin: Bool){
    
    // create viewController code...
    
    if sharedAppdelegate.appLanguage == .English{
        let leftMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = AppStoryboard.ChatView.instance.instantiateViewController(withIdentifier: "MessagesID") as! MessagesVC
        mainViewController.chatInfo = chatInfo
        mainViewController.isPush = true
        mainViewController.isAdmin = isAdmin
        if let userId = chatInfo["receiver_id"]{
            
            mainViewController.user_id = "\(userId)"
            
        }

        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        let leftslideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        leftslideMenuController.mainViewController = sharedAppdelegate.nvc
        leftslideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = leftslideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
        
    }else{
        
        let rightMenuViewController = sideMenuStoryboard.instantiateViewController(withIdentifier: "LeftSlideMenuID") as! LeftSlideMenuVC
        let mainViewController = AppStoryboard.ChatView.instance.instantiateViewController(withIdentifier: "MessagesID") as! MessagesVC
        sharedAppdelegate.nvc = UINavigationController(rootViewController: mainViewController)
        mainViewController.chatInfo = chatInfo
        mainViewController.isPush = true
        mainViewController.isAdmin = isAdmin

        if let userId = chatInfo["receiver_id"]{
            mainViewController.user_id = "\(userId)"

        }

        let rightSideMenuController = SlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController)
        sharedAppdelegate.nvc.isNavigationBarHidden = true
        sharedAppdelegate.nvc.automaticallyAdjustsScrollViewInsets = false
        rightSideMenuController.mainViewController = sharedAppdelegate.nvc
        rightSideMenuController.automaticallyAdjustsScrollViewInsets = true
        sharedAppdelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        sharedAppdelegate.window?.rootViewController = rightSideMenuController
        sharedAppdelegate.window?.makeKeyAndVisible()
        
    }
    
}






func makeLbl(view: UIView,msg: String) -> UILabel{
    
    let tablelabel = UILabel(frame: CGRect(x: view.center.x, y: view.center.y, width: view.frame.width, height: view.frame.height))
    tablelabel.font = UIFont.init(name:"SFUIDisplay-Regular" , size: 15)
    tablelabel.textColor = UIColor.black
    tablelabel.textAlignment = .center
    tablelabel.text = msg.localized
    return tablelabel
    
}


func setDateFormate(dateString: String) -> String{

    let forematter = DateFormatter()
    forematter.locale = Locale(identifier: "en_US_POSIX")
    forematter.timeZone = TimeZone(abbreviation: "UTC")
    forematter.dateFormat = "yyyy-MM-dd hh:mm a"
    

    guard let utc_date = forematter.date(from: dateString) else{return ""}
    forematter.timeZone = NSTimeZone.local
    forematter.locale = NSLocale.current
    return  utc_date.timeAgo


}


func setDateFormateWith_24Hrs(dateString: String) -> String{
    
    let forematter = DateFormatter()
    forematter.locale = Locale(identifier: "en_US_POSIX")
    forematter.timeZone = TimeZone(abbreviation: "UTC")
    forematter.dateFormat = "yyyy-MM-dd hh:mm a"
    
    
    guard let utc_date = forematter.date(from: dateString) else{return ""}
    
    return stringFromDate(date: utc_date, dateFormat: "d MMM yyyy, h:mm a")
    
    
}


func stringFromDate(date:Date, dateFormat:String,timeZone:TimeZone = TimeZone.current)->String{
    
    let frmtr = DateFormatter()
    frmtr.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    frmtr.dateFormat = dateFormat
    frmtr.timeZone = timeZone
    return frmtr.string(from: date)
}

func dateFromString(dateString:String, dateFormat:String,timeZone:TimeZone = TimeZone.current)->Date?{
    
    let frmtr = DateFormatter()
    frmtr.locale = Locale(identifier: "en_US_POSIX")
    frmtr.dateFormat = dateFormat
    frmtr.timeZone = timeZone
    return frmtr.date(from: dateString)
}



func setDateFormateWithTimeZone(dateString: String) -> String{
    
    let forematter = DateFormatter()
    forematter.locale = Locale(identifier: "en_US_POSIX")
    forematter.timeZone = TimeZone(abbreviation: "UTC")

    forematter.dateFormat = "yyyy-MM-dd hh:mm a"
    
    guard let utc_date = forematter.date(from: dateString) else{return ""}

    forematter.timeZone = NSTimeZone.local
    forematter.locale = NSLocale.current
    forematter.dateFormat = "yyyy-MM-dd hh:mm a"

    return forematter.string(from: utc_date)
    
//    if date == nil{
//        
//        forematter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
//        
//        date = forematter.date(from: dateString)
//        
//    }
//    
//    let timeString = forematter.string(from: date!)
//    
//        return timeString
    
}



//func convertCurrentToUTC(dateString: String) -> String{
//    
//    let forematter = DateFormatter()
//    forematter.locale = Locale(identifier: "en_US_POSIX")
//    forematter.timeZone = NSTimeZone.local
//    forematter.locale = NSLocale.current
//
//    forematter.dateFormat = "yyyy-MM-dd hh:mm a"
//    
//    guard let utc_date = forematter.date(from: dateString) else{
//        
//        forematter.dateFormat = "yyyy-MM-dd hh:mm:s"
//        let u_time = forematter.date(from: dateString)!
//        forematter.timeZone = TimeZone(abbreviation: "UTC")
//        
//        forematter.dateFormat = "yyyy-MM-dd hh:mm"
//        
//        return forematter.string(from: u_time)
//
//    }
//    
//    forematter.timeZone = TimeZone(abbreviation: "UTC")
//
//    forematter.dateFormat = "yyyy-MM-dd hh:mm"
//    
//    return forematter.string(from: utc_date)
//    
//    //    if date == nil{
//    //
//    //        forematter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
//    //
//    //        date = forematter.date(from: dateString)
//    //
//    //    }
//    //
//    //    let timeString = forematter.string(from: date!)
//    //    
//    //        return timeString
//    
//}


// xmpp setup
func chatSetup() {
    XMPPhelper.sharedInstance().userName = CurrentUser.user_id!
    if XMPPhelper.sharedInstance().connect() {
        print_debug(object: "connect")
    }
    
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

func getIndexPathforCellItem(item: AnyObject, inTable tableView: UITableView) -> NSIndexPath? {
    let buttonPosition: CGPoint = item.convert(CGPoint.zero, to: tableView)
    return tableView.indexPathForRow(at: buttonPosition) as NSIndexPath?
}

//MARK: Chat

var documentsDirectoryPath:String {
    
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    return paths.first!
}


// MARK: SAVE IMAGE TO DOCUMENT DIRECTORY
func saveImageToDocumentDirectory(_ image:UIImage,path:String)->String{
    
    let writePath = documentsDirectoryPath.stringByAppendingPathComponent(path: "\(path).png")
    try? UIImagePNGRepresentation(image)!.write(to: URL(fileURLWithPath: writePath), options: [.atomic])
    return writePath
}

func removeFilesFromDocumentDirectory(fileName:String = ""){
    
    let fileManager = FileManager.default
    if let directoryContents = try? fileManager.contentsOfDirectory(atPath: documentsDirectoryPath){
        
        for path in directoryContents {
            
            if fileName.isEmpty || path.contains(fileName) {
                let fullPath = documentsDirectoryPath.stringByAppendingPathComponent(path: path)
                if let _ = try? fileManager.removeItem(atPath: fullPath){
                    print_debug(object: "deleted at given path")
                }
                else {
                    print_debug(object: "Could not retrieve directory")
                }
            }
        }
    }
    else {
        print_debug(object: "Could not retrieve directory")
    }
}

func clearTempDirectory() {
    let fileManager = FileManager.default
    let tempFolderPath = NSTemporaryDirectory()
    
    do {
        let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
        for filePath in filePaths {
            try fileManager.removeItem(atPath: NSTemporaryDirectory() + filePath)
        }
    } catch let error as NSError {
        print_debug(object: "Could not clear temp folder: \(error.debugDescription)")
    }
}

func getMainQueue(closure:@escaping ()->()){
    DispatchQueue.main.async {
        closure()
    }
}



func getJsonObject(Detail: AnyObject) -> String{
    
    var data = NSData()
    do {
        data = try JSONSerialization.data(
            withJSONObject: Detail ,
            options: JSONSerialization.WritingOptions(rawValue: 0)) as NSData
    }
    catch{
        
    }
    let paramData = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
    return paramData
}


 func covert_UTC_to_Local(date:String) -> String{
    
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    let date1 = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "MM-dd-yyyy"
    
    dateFormatter.timeZone = NSTimeZone.local
    
    dateFormatter.locale = NSLocale.current
    
    let strDate = dateFormatter.string(from: date1!)
    
    return strDate
    
}



 func setEvent(eventName: String , params : [String: NSObject]){
    
    Analytics.logEvent(eventName, parameters: params)
    
}





extension Notification.Name {
    
    public static let myNotificationKey = Notification.Name(rawValue: "myNotificationKey")
    public static let listPopupNotificationKey = Notification.Name(rawValue: "myNotificationKey")
    public static let timeLineNotificationKey = Notification.Name(rawValue: "timeLineNotificationKey")


}


func flipImageLeftRight(_ image: UIImage) -> UIImage? {
    
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()!
    context.translateBy(x: image.size.width, y: image.size.height)
    context.scaleBy(x: -image.scale, y: -image.scale)
    
    context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return newImage
}



func openUrlLink(_ url: String){
    
    let openUrl = URL(string: url)
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(openUrl!, options: [:])
    } else {
        UIApplication.shared.openURL(openUrl!)
    }
    
}


extension UIButton{
    
    func rotateBackImage(){
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.setImage(#imageLiteral(resourceName: "ic_following_back").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }else{
            self.setImage(#imageLiteral(resourceName: "ic_following_back"), for: .normal)
            
        }
    }

}
