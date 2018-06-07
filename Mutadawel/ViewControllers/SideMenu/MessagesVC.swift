//
//  MessagesVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 21/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessagesVC: MutadawelBaseVC, XMPPStreamDelegate {
    
    //MARK:- IBOutlets
    //MARK:- ==========================================

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var popUpBGView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var deleteConversationBtn: UIButton!
    @IBOutlet weak var muteNotiBtn: UIButton!
    @IBOutlet weak var conectivityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var blockUserButton: UIButton!
    @IBOutlet weak var popUpViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    //MARK:- ==========================================

    var selectedIndexPath: NSIndexPath?
    var profileState = ProfileState.SideMenu
    
    var chatObjectsArray:[XMPPMessageArchiving_Contact_CoreDataObject] = []
    var contactPuchedObj  : XMPPMessageArchiving_Contact_CoreDataObject?
    var fetchedResultsController_messageArchive:NSFetchedResultsController<NSFetchRequestResult>?
    var user_id = ""
    var editableIndexPath:IndexPath?
    var usersArr:JSONArray = []
    var chatInfo = JSONDictionary()
    var isPush = false
    var isAdmin = false
 
    
    //MARK:- View life cycle methods
    //MARK:- ==========================================

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        print_debug(object: documentsPath)
        
        if CurrentUser.user_id != nil{
            
            readNotificationAPI(params: ["userId":CurrentUser.user_id as AnyObject])
            
        }
        userDefaults.removeObject(forKey: UserDefaultsKeys.chat_notification_count)
        if self.isPush{
            
            self.chatSetUp()
            self.backBtn.setImage(ButtonImg.burgerBtn, for: UIControlState.normal)
        }else{
            
            self.backBtn.rotateBackImage()
        }

        self.initialViewStup()
        self.initialSetup()
        self.updateStatus()

        
        XMPPhelper.sharedInstance().xmppStream.addDelegate(self, delegateQueue:DispatchQueue.main)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
        //XMPPhelper.sharedInstance()?.xmppStream.removeDelegate(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
            if let view = touches.first?.view {
                
                if view == self.popUpBGView && !self.popUpBGView.subviews.contains(view) {
                    
                    self.popUpBGView.isHidden = true
                }
            }
        
    }
    
    
    //MARK:- private methods
    //MARK:- ==========================================

   private func initialViewStup(){
        
        self.navigationTitle.text = MESSAGES.localized
        self.deleteConversationBtn.setTitle(DELET_CONVERSATION_BTN.localized, for: .normal)
        self.muteNotiBtn.setTitle(MUTE_NOTIFICATION_BTN.localized, for: .normal)
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationView.backgroundColor = AppColor.navigationBarColor
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        self.chatBtn.layer.cornerRadius = 25
        self.popUpBGView.isHidden = true
        self.chatBtn.isHidden = false
        self.blockUserButton.setTitle(BLOCK_USER.localized, for: .normal)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(longPressGesture:)))
        longPressGesture.minimumPressDuration = 1.0 // 2 second press
        longPressGesture.delegate = self
        self.messagesTableView.addGestureRecognizer(longPressGesture)
        
    }
    
    func initialSetup(){
        
        if let moc = XMPPhelper.sharedInstance().managedObjectContext_messageArchive(){
            
            let entityDescription = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Contact_CoreDataObject", in: moc)
            let sortDescriptor = NSSortDescriptor(key: "mostRecentMessageTimestamp", ascending: false)
            let sortDescriptors = [sortDescriptor]
            let request = NSFetchRequest<NSFetchRequestResult>()
            request.sortDescriptors = sortDescriptors
            request.fetchBatchSize = 20
            request.entity = entityDescription
            
            let predicate = NSPredicate(format: "streamBareJidStr = '\(self.user_id)@\(xmppHostNameJidSubString)'")
            //let blankString = xmppHostNameJidSubString as! String
            let predicateNotNull = NSPredicate(format: "bareJidStr != '\(xmppHostName)' ")
            
            
            let compound_predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,predicateNotNull])
            request.predicate = compound_predicate
            
            
            self.fetchedResultsController_messageArchive =
                NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchedResultsController_messageArchive?.delegate = self
            try? self.fetchedResultsController_messageArchive?.performFetch()
        }
        
        if self.isPush{
            
            let vc = AppStoryboard.ChatView.instance.instantiateViewController(withIdentifier: "ChatViewControllerSwift") as! ChatViewControllerSwift
            vc.isAdmin = self.isAdmin
            
            if !self.isAdmin{
            if let userId = self.chatInfo["receiver_id"],let other_id = self.chatInfo["sender_id"],let user_name = self.chatInfo["user_name"]{
                
                vc.user_id = "\(userId)"
                vc.other_user_id = "\(other_id)"
                vc.otherUserName = "\(user_name)"
                
				}
            }
            sharedAppdelegate.nvc.pushViewController(vc, animated: true)
            
        }
            self.filterChat()


        
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        self.updateStatus()
    }
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error!) {
        self.updateStatus()
    }
    
    
    func updateStatus()  {
        if ((XMPPhelper.sharedInstance().xmppStream.isConnected() == false) || (XMPPhelper.sharedInstance().xmppStream.isAuthenticated() == false)){
            //connecting
            self.conectivityView.isHidden = false
            self.navigationTitle.isHidden = true
        } else {
            //show normal title
            self.conectivityView.isHidden = true
            self.navigationTitle.isHidden = false
        }
    }
    
    
    
    func filterChat(){
        
        self.chatObjectsArray = []
        
        guard let fetchedObjects = self.fetchedResultsController_messageArchive?.fetchedObjects as? [XMPPMessageArchiving_Contact_CoreDataObject] else{
            return
        }
        self.chatObjectsArray = fetchedObjects //.append(contentsOf: fetchedObjects)
        
        self.getUserListFromLocalServer()
    }
    
    
    func getUserListFromLocalServer(){
        
        guard self.chatObjectsArray.count > 0 else {
            
            return
        }
        
        if (self.isViewLoaded && (self.view.window != nil)) {
            showLoader()
        }
        
        var users = ""
        for item in self.chatObjectsArray {
            
            users += ((users != "" ? ",":"")+item.bareJidStr!.replacingOccurrences(of: ("@"+xmppHostNameJidSubString), with: ""))
            
            
        }
        
        var params = JSONDictionary()
        params["user_id"] = self.user_id
        params["ids"] = users
        
        
        chatListAPI(params: params) { (success, msg, data) in
            hideLoader()
            
            if success{
                
                if !data!.isEmpty{
                    
                    self.usersArr = data!
                    for userInfo in self.usersArr {
                        let status = userInfo["status"].intValue
                        if status == 2 {
                            let userId = userInfo["id"].intValue
                            self.deleteUser(userId: "\(userId)")
                        }
                    }
                }
                else{
                    self.usersArr = []
                }
                print_debug(object: data)
                self.messagesTableView.reloadData()
            }
            
        }
        
    }
    
    
    func deleteUser(userId : String) {
        
        let predicate1 = NSPredicate(format: "bareJidStr = '\(userId)@\(xmppHostNameJidSubString)'")
        
        let compound_predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
        
        if let objArr = fetchData(modelName: NSStringFromClass(XMPPMessageArchiving_Contact_CoreDataObject.self), predicateValue: compound_predicate) as? [XMPPMessageArchiving_Contact_CoreDataObject]{
            
            let tempArr = objArr.filter({ objTemp -> Bool in
                
                let businessidTemp = objTemp.bareJidStr
                return ("'\(user_id)@\(xmppHostNameJidSubString)'" == businessidTemp)
            })
            deleteModels(managedObjects: tempArr)
        }
    }
    
    
    //Date functions
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
    
    func isEqualToDateIgnoringTime(date1: Date,date2: Date) -> Bool
    {
        let calendar = Calendar.current
        
        let year1 = calendar.component(.year, from: date1)
        let year2 = calendar.component(.year, from: date2)
        
        let month1 = calendar.component(.month, from: date1)
        let month2 = calendar.component(.month, from: date2)
        
        let day1 = calendar.component(.day, from: date1)
        let day2 = calendar.component(.day, from: date2)
        
        return ((year1 == year2) && (month1 == month2) && (day1 == day2))
    }
    
    
    func getTimeString(date:Date)->String?{
        
        if self.isEqualToDateIgnoringTime(date1: Date(),date2: date){
            
            return self.stringFromDate(date: date, dateFormat: "hh:mm a").uppercased()
        }
        else if self.isEqualToDateIgnoringTime(date1: Date().addDays(-1),date2: date){
            return "Yesterday".uppercased()
        }
        else if self.isEqualToDateIgnoringTime(date1: Date().addDays(-2),date2: date){
            return "2 days ago".uppercased()
        }
        else if self.isEqualToDateIgnoringTime(date1: Date().addDays(-3),date2: date){
            return "3 days ago".uppercased()
        }
        return self.stringFromDate(date: date, dateFormat: "MMM dd").uppercased()
    }
    
    
    //MARK:- IBActions
    //MARK:- ==========================================

    
    @IBAction func backBtnTappe(_ sender: UIButton) {
        
        if sharedAppdelegate.appLanguage == .English{
            if self.isPush{
                
                openLeft()
                
            }else{
                
                sharedAppdelegate.nvc.popViewController(animated: true)
            }
            
        }else{
            
            if self.isPush{
                
                openRight()
                
            }else{
                
                sharedAppdelegate.nvc.popViewController(animated: true)
            }
            
        }
        
    }
    
    
    @IBAction func chatBtnTapped(_ sender: UIButton) {
        
        let obj = settingsStoryboard.instantiateViewController(withIdentifier: "MyFollowingID") as! MyFollowingVC
        if CurrentUser.user_id != nil{
            obj.userID = currentUserId()
        }
        obj.userType = .User
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    
    
    @IBAction func deleteConversationTappd(_ sender: UIButton) {
        
        self.popUpBGView.isHidden = true
        self.popUpView.isHidden = true
        
        let alertController = UIAlertController(title: "", message: k_Do_you_want_delete_user.localized, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertActionGallery = UIAlertAction(title: k_Delete.localized, style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            
            
            if let indexPath = self.editableIndexPath {
                let obj = self.chatObjectsArray[indexPath.row]
                //let actualBusinessId = obj.ids
                
                let predicate1 = NSPredicate(format: "bareJidStr = '\(obj.bareJidStr!)'")
                let predicate2 = NSPredicate(format: "streamBareJidStr = '\(self.user_id)@\(xmppHostNameJidSubString)'")
                
                let compound_predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
                
                if let objArr = fetchData(modelName: NSStringFromClass(XMPPMessageArchiving_Contact_CoreDataObject.self), predicateValue: compound_predicate) as? [XMPPMessageArchiving_Contact_CoreDataObject]{
                    
                    let tempArr = objArr.filter({ objTemp -> Bool in
                        
                        let bareJidStr = objTemp.bareJidStr
                        return (obj.bareJidStr! == bareJidStr)
                    })
                    deleteModels(managedObjects: tempArr)
                    self.messagesTableView.reloadData()
                }
                self.filterChat()
                self.messagesTableView.reloadData()

            }
        }
        
        let alertActionCamera = UIAlertAction(title:
        CANCEL.localized , style: UIAlertActionStyle.default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(alertActionGallery)
        alertController.addAction(alertActionCamera)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func muteNotificationTappd(_ sender: UIButton) {
        
        self.popUpBGView.isHidden = true
        self.popUpView.isHidden = true
        
        var params = JSONDictionary()
        
        
        //guard  let userInfo = usersArr[(editableIndexPath?.row)!], let mutedId = userInfo["id"], let status = userInfo["mute"] else {return}
        showLoader()
        
        let userInfo = usersArr[(editableIndexPath?.row)!]
        let mutedId = userInfo["id"].intValue
        let status = userInfo["mute"].intValue
        
        params["mutedId"] = mutedId
        
        params["userId"] = CurrentUser.user_id
        
        if status == 2{
            params["action"] = 1

        }else{
            params["action"] = 2

        }
        
        muteUserNoificationAPI(params: params) { (success, msg, data) in
            if success{
                
                hideLoader()
                
                var userInfo = self.usersArr[(self.editableIndexPath?.row)!]
                
                if status == 2{
                    
                    userInfo["mute"] = 1
                    
                }else{
                    
                    userInfo["mute"] = 2
                    
                }

                self.usersArr[(self.editableIndexPath?.row)!] = userInfo
                
            }
        }
        
        
    }
    
    @IBAction func blockUserTappd(_ sender: Any) {
        self.popUpBGView.isHidden = true
        self.popUpView.isHidden = true
        
        var params = JSONDictionary()
        
        if CurrentUser.user_id != nil{
            params["blockerId"] = CurrentUser.user_id
            //params["userId"] = CurrentUser.user_id

        }
        //guard  let userInfo = usersArr[(editableIndexPath?.row)!] as? [String:AnyObject], let blockedId = userInfo["id"] else {return}
        showLoader()
        let userInfo = usersArr[(editableIndexPath?.row)!]
        let blockedId = userInfo["id"].intValue
        params["blockedId"] = blockedId
        
        blockUserAPI(params: params) { (success, msg, data) in
            if success{
                hideLoader()
                var userInfo = self.usersArr[(self.editableIndexPath?.row)!]
                userInfo["status"] = 3
                self.usersArr[(self.editableIndexPath?.row)!] = userInfo
            }
            showToastWithMessage(msg: msg)
        }
    }
}


//MARK:- UItable view delegate and datasource
//MARK:- ================================================

extension MessagesVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            
            return 1
            
        }else{
            
            var count = 0
            
            if self.usersArr.count > 0{
                
                count = self.chatObjectsArray.count
            }
            
            return count

        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
        cell.profileBtn.addTarget(self, action: #selector(self.userProfileTapped(_:)), for: .touchUpInside)
        
        if indexPath.section == 0{
            
            cell.profileBtn.isEnabled = false
            
        }else{
            
            cell.profileBtn.isEnabled = true

        }
        if indexPath.section == 0{
            
            cell.userNameLbl.text = ADMIN.localized
            
            cell.timeLbl.text = ""
            
        }else{
        
        let obj = self.chatObjectsArray[indexPath.row]
        
        var userInfoDict:JSON?
        
        let other_user_id = obj.bareJidStr!.replacingOccurrences(of: ("@"+xmppHostNameJidSubString), with: "")
            
        let tempUsersArr = self.usersArr.filter { dict -> Bool in
            
            let userid = dict["id"].stringValue
            
            if userid == other_user_id{
                
                return true
                
            }
            
            return false
        }
            
        userInfoDict = tempUsersArr.first
        
        
        
        if let userInfoDictTemp = userInfoDict{
            
            let userName = userInfoDictTemp["name"].string ?? "Unknown"
            cell.userNameLbl.text = userName
            if let profileimage = userInfoDictTemp["profile_pic"].string, let url = URL(string: profileimage){
                cell.userImg.sd_setImage(with: url, placeholderImage: UIImage(named:"ic_following_placeholder"))
            }
            else{
                
                cell.userImg.image = UIImage(named:"ic_following_placeholder")
            }
        }
        else{
            
            cell.userImg.image = UIImage(named:"ic_following_placeholder")
            
            cell.userNameLbl.text = "Unknown"
            
        }
        
        if obj.isReadStr == "0" && obj.mostRecentMessageOutgoing == NSNumber(value: 0) {
            
            cell.bgView.backgroundColor = UIColor.lightGray
            
        }else{
            
            cell.bgView.backgroundColor = UIColor.white
        }
            
        cell.timeLbl.text = self.getTimeString(date: obj.mostRecentMessageTimestamp)
            
        cell.descriptionLbl.text = obj.mostRecentMessageBody
        
        cell.userImg.backgroundColor = UIColor.blue
            
            
    }
        return cell
        
}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = AppStoryboard.ChatView.instance.instantiateViewController(withIdentifier: "ChatViewControllerSwift") as! ChatViewControllerSwift

        if indexPath.section == 0{
            
            vc.isAdmin = true
        
        }else{
        
        vc.isAdmin = false

        let obj = self.chatObjectsArray[indexPath.row]
        var userInfoDict:JSON?
        
        let other_user_id = obj.bareJidStr!.replacingOccurrences(of: ("@"+xmppHostNameJidSubString), with: "")
        let tempUsersArr = self.usersArr.filter { dict -> Bool in
            let userid = dict["id"].stringValue
            if userid == other_user_id{
                //setReadForIDS
                return true
            }
            return false
        }
        
        userInfoDict = tempUsersArr.first
        
        if let userInfoDictTemp = userInfoDict{
            
            let isBlocked = userInfoDictTemp["status"].intValue
            if isBlocked == 3{
                return
            }
            let userName = userInfoDictTemp["name"].string ?? "Unknown"
            vc.otherUserName = userName
            if let profileimage = userInfoDictTemp["profile_pic"].string{
                vc.otherUserProfileImageUrl = profileimage
            }
        }
        
        vc.other_user_id = obj.bareJidStr!.replacingOccurrences(of: ("@"+xmppHostNameJidSubString), with: "")
        
        vc.recieverId = obj.bareJidStr!.replacingOccurrences(of: ("@"+xmppHostNameJidSubString), with: "")

        vc.user_id = self.user_id
        self.contactPuchedObj = obj;
        vc.contactObject = obj
            
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func userProfileTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.messagesTableView) else{return}
        
        if indexPath.row < self.usersArr.count - 1{
            let data = self.usersArr[indexPath.row + 1]
                let userId = data["id"].intValue
                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                obj.userID = userId
                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        }

        }
    
}


//MARK:- Fetchresult delegate
//MARK:- ===================================

extension MessagesVC: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.filterChat()
    }
}


//MARK:- UIgesture recognition delegate
//MARK:- ===================================

extension MessagesVC : UIGestureRecognizerDelegate {
    
    func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        
        let p = longPressGesture.location(in: self.messagesTableView)
        print_debug(object: p)
        let indexPath = self.messagesTableView.indexPathForRow(at: p)
        
        if indexPath == nil {
            
            print_debug(object: "Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.began) {

        if indexPath?.section == 1{
            
            print_debug(object: "Long press on row, at \(indexPath!.row)")
            
            self.editableIndexPath = indexPath
            
            if (indexPath?.row)! > usersArr.count {
                
                return
            }
            
            print_debug(object: usersArr[(indexPath?.row)!])
            
            let userInfo = usersArr[(indexPath?.row)!]
            
            let status = userInfo["status"].stringValue
            
            if status == "3" {
                
                self.popUpViewHeightConstraint.constant = CGFloat((2 * 35) + 40 + 8)
                self.blockUserButton.isHidden = true
                
            } else {
                
                self.popUpViewHeightConstraint.constant = CGFloat((3 * 35) + 40 + 16)
                self.blockUserButton.isHidden = false
            }
            
            if let status = userInfo["mute"].string , "\(status)" == "2" {
                self.muteNotiBtn.setTitle(MUTE_NOTIFICATION_BTN.localized, for: .normal)
            } else {
                self.muteNotiBtn.setTitle(UNMUTE_NOTIFICATION_BTN.localized, for: .normal)
            }
            
            popUpBGView.isHidden = false
            popUpView.isHidden = false
            
            }
        }
    }
}


//MARK:- cell classess

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView(){
        
        self.userImg.layer.cornerRadius = 20
        self.userImg.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

//MARK:- =================================
//MARK:- Chat setup

extension MessagesVC {
    
    func chatSetUp() {
        DispatchQueue.main.async {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(self.managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: XMPPhelper.sharedInstance().managedObjectContext_messageArchive())
        }
    }
    
    
    
    func managedObjectContextObjectsDidChange(notification: NSNotification?){
        
        print_debug(object: XMPPhelper.sharedInstance().getUnreadMessageContactForHome())
        
        
    }
    
    
}
