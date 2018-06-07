//
//  ChatViewControllerSwift.swift
//  XMPPChatDemo
//
//  Created by saurabh on 14/12/16.
//  Copyright © 2016 saurabh. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import AVFoundation
import AssetsLibrary
import MapKit
//import IQKeyboardManagerSwift
import TOCropViewController
import SKPhotoBrowser
import Photos
import Alamofire

class ChatViewControllerSwift: UIViewController,XMPPStreamDelegate {
    
    
    //MARK:- IBOutlets
    //MARK:- ==========================================
    
    @IBOutlet weak var otherUserNameLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var chatTableContainerView: UIView!
    @IBOutlet var attachmentView: UIView!
    @IBOutlet weak var chatTableView:UITableView!
    @IBOutlet weak var sendButton:UIButton!
    @IBOutlet weak var cameraButton:UIButton!
    @IBOutlet weak var textFiledContainerView:UIView!
    @IBOutlet weak var textView:TextViewPlaceHolderSupport!
    @IBOutlet weak var textViewContainerHeight:NSLayoutConstraint!
    @IBOutlet weak var textContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectivityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton!
    
    
    //MARK:- Properties
    //MARK:- ==========================================
    
    var fetchedResultsController_messageArchive:NSFetchedResultsController<NSFetchRequestResult>?
    var reachable = false
    var user_id: String = ""
    var other_user_id: String = ""
    var recieverId:String = ""
    var otherUserProfileImageUrl = ""
    var otherUserName = ""
    var menuImages = [SKPhoto]()
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    var isAdmin = false
    var feedbackMessageList = [ChatModel]()
    var selectedIdx:IndexPath?
    
    var chatObjectsArray:[XMPPMessageArchiving_Message_CoreDataObject] = []
    var contactObject : XMPPMessageArchiving_Contact_CoreDataObject?
    var keyboardShow: NSObjectProtocol?, keyboardHide: NSObjectProtocol?
    
    
    //MARK:- View life cycle methods
    //MARK:- ==========================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.initializeRefreshControl()
        if CurrentUser.user_id != nil{
            self.user_id = CurrentUser.user_id!
        }
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        
        self.chatTableView.addGestureRecognizer(tapGesture)
        
        NSLog("otheruserid--->%@----/\n ", self.other_user_id)
        NSLog("myuserid--->%@----/\n ", self.user_id)
        XMPPhelper.sharedInstance().currentOtherUser = "\(self.other_user_id)"
        self.initialSetup()
        self.updateStatus()
        self.textView.placeholder = SEND_NEW_MSG.localized
        self.backButton.rotateBackImage()
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.sendButton.setImage(#imageLiteral(resourceName: "ic_add_new_post_sent").imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }else{
            self.sendButton.setImage(#imageLiteral(resourceName: "ic_add_new_post_sent"), for: .normal)
            
        }
        
        XMPPhelper.sharedInstance().xmppStream.addDelegate(self, delegateQueue:DispatchQueue.main)
        
        delay(1.0) {
            self.sendReadStatusToOtherUserForLastmessage()
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification:Notification!) -> Void in
            
            self.view.addGestureRecognizer(tapGesture)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { _ in
            
            self.view.removeGestureRecognizer(tapGesture)
        }
        
        self.reachabilityManager?.startListening()
        self.navigationController?.isNavigationBarHidden = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        addKeyBoardSetup()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.chatTableView.reloadData()
        
        delay(0.2) {
            self.moveToLatestChatMessage()
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        //      self.chatTableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //XMPPhelper.sharedInstance().currentOtherUser = nil;
        self.readAllMessages()
        self.setReadContact()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.reachabilityManager?.stopListening()
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        removeKeyBoardSetup()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func becomeFirstResponder() -> Bool {
        
        super.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(self.willHideEditMenu), name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willHideEditMenu), name: NSNotification.Name.UIMenuControllerDidHideMenu, object: nil)
        return true
        
    }
    
    override var canBecomeFirstResponder: Bool {
        
        return true
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if (#selector(copyText) == action) {
            
            return true
        }else{
            
            return false
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    
    deinit {
        
        self.fetchedResultsController_messageArchive?.delegate = nil
        self.textView?.delegate = nil
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: SEND_PUSH_CHAT) , object: nil)
        XMPPhelper.sharedInstance().xmppStream.removeDelegate(self)
        
    }

    
    //MARK:-  Methods
    //MARK:- ==========================================
    
    
    func willHideEditMenu(){
        
        self.selectedIdx = nil
        self.chatTableView.reloadData()
        
    }
    
    
    func dismissKeyboard(_sender: AnyObject){
        
        self.view.endEditing(true)
        
    }
    
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        self.updateStatus()
    }
    
    
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error!) {
        self.updateStatus()
    }
    
    
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        if message.hasMarkableChatMarker() {
            
            if message.from().user == "\(self.other_user_id)" {
                let message : XMPPMessage  = message.generateDisplayedChatMarker()
                sender.send(message)
            }
        }
        if message.from().user == "\(self.other_user_id)" {
        }
        
    }
    
    
    func updateStatus()  {
        if ((XMPPhelper.sharedInstance().xmppStream.isConnected() == false) || (XMPPhelper.sharedInstance().xmppStream.isAuthenticated() == false)){
            //connecting
            self.connectivityView.isHidden = false
            self.otherUserNameLbl.isHidden = true
        } else {
            // show normal title
            self.connectivityView.isHidden = true
            self.otherUserNameLbl.isHidden = false
        }
    }
    
    
    func setReadContact(){
        
        if !self.other_user_id.isEmpty {
            XMPPhelper.sharedInstance().setReadForIDS(self.other_user_id)
        }
        
    }
    
    
    func initialSetup(){
        
        self.backButton.rotateBackImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewControllerSwift.sendRemotePush(_:)), name: NSNotification.Name(rawValue: SEND_PUSH_CHAT), object: nil)
        
        self.chatTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.chatTableView.bounds.width, height: 20))
        self.textView.placeholder = "Send Message"
        self.textView.hideBorder = true
        self.textView.delegate = self
        self.textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.textView.layer.borderWidth = 1.0
        
        
        if self.isAdmin{
            
            self.otherUserNameLbl.text = ADMIN.localized
            self.cameraButton.isHidden = true
            self.getFeedbackMessages()
            
            
        }else{
            
            self.otherUserNameLbl.text = self.otherUserName
            self.clickOnMessageService()
        }
        
        
        if let stream = XMPPhelper.sharedInstance()?.xmppStream{
            
            if stream.isAuthenticated(){
                
                self.sendButton.isEnabled = false
            }
        }
        
        DispatchQueue.main.async {
            
            self.moveToLatestChatMessage(animate:false)
        }
        self.view.layoutSubviews()
        
        self.reachabilityManager?.listener = { status in
            
            print_debug(object:"Network Status Changed: \(status)")
            switch status {
            case .notReachable,.unknown:
                self.reachable = false
                self.sendButton.isEnabled = false
            //Show error state
            case .reachable(_):
                self.reachable = true
                self.sendButton.isEnabled = true
            }
        }
        
        if let moc = XMPPhelper.sharedInstance().managedObjectContext_messageArchive(){
            
            let entityDescription = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Message_CoreDataObject", in: moc)
            let sortDescriptor = NSSortDescriptor(key: "sortedTimeStamp", ascending: true)
            let sortDescriptors = [sortDescriptor]
            let request = NSFetchRequest<NSFetchRequestResult>()
            request.sortDescriptors = sortDescriptors
            request.fetchBatchSize = 20
            request.entity = entityDescription
            
            
            let predicate1 = NSPredicate(format: "bareJidStr = '\(self.other_user_id)@\(xmppHostNameJidSubString)'")
            let predicate2 = NSPredicate(format: "streamBareJidStr = '\(self.user_id)@\(xmppHostNameJidSubString)'")
            
            let compound_predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
            request.predicate = compound_predicate
            
            
            
            self.fetchedResultsController_messageArchive =
                NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchedResultsController_messageArchive?.delegate = self
            try? self.fetchedResultsController_messageArchive?.performFetch()
        }
        //XMPPhelper.sharedInstance().chatViewController = self;
        self.filterChat()
        self.backButton.setImage(UIImage(named: sharedAppdelegate.appLanguage == .English ? "ic_sign_in_back" : "ic_sign_in_back"), for: UIControlState.normal)
        
    }
    
    
    func clickOnMessageService(){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id ?? ""
        params["platform"] = "2"
        
        messageClick(params: params) { (success, msg, data) in
            
            print_debug(object: "Clicked Message")
        }
    }

    
    func getFeedbackMessages(){
        
        var params = JSONDictionary()
        params["userId"] = CurrentUser.user_id ?? ""
        
        
        feedbackAPI(params: params) { (success, msg, data) in
            
            if success{
                
                self.feedbackMessageList = data!.map({ (chat) -> ChatModel in
                    ChatModel(withData: chat)
                })
                self.chatTableView.reloadData()
                self.chatTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                
                delay(0.4) {
                    self.moveToLatestChatMessage()
                    
                }
                //self.view.layoutSubviews()
            }
        }
    }
    
    
    fileprivate func addKeyBoardSetup() {
        
        self.keyboardShow = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [unowned self] (notification:Foundation.Notification!) ->  Void in
            if let keyboard = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.textContainerBottomConstraint.constant = keyboard.cgRectValue.size.height
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        self.keyboardHide = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [unowned self] (notification:Foundation.Notification!) -> Void in
            UIView.animate(withDuration: 0.3, animations: {
                
                self.textContainerBottomConstraint?.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    fileprivate func removeKeyBoardSetup() {
        
        if let show = self.keyboardShow {
            NotificationCenter.default.removeObserver(show, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        }
        
        if let hide = self.keyboardHide {
            NotificationCenter.default.removeObserver(hide, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
	
    
    func readAllMessages(){

        for item in self.chatObjectsArray {
            item.isRead = NSNumber(value:1)
        }
        
        saveContext()
    }
	
    
    func filterChat(){
        
        self.chatObjectsArray = []
        if let fetchedObjects = self.fetchedResultsController_messageArchive?.fetchedObjects as? [XMPPMessageArchiving_Message_CoreDataObject]{
            
            self.chatObjectsArray = fetchedObjects
        }
        
        self.imageSetup()
        self.chatTableView.reloadData()
        
    }
	
    func sendReadStatusToOtherUserForLastmessage(){
        
        XMPPhelper.sharedInstance().sendStatusAsDisplayedForMessages(forUserId: self.other_user_id)
        
    }
    
    func imageSetup() {
        
        self.menuImages.removeAll()
        for item in self.chatObjectsArray {
            let bandURI = item.message?.outOfBandURI() ?? ""
            let description = item.message?.outOfBandDesc()
            if description == "1" {
                let photo = SKPhoto.photoWithImageURL(bandURI)
                if !self.menuImages.contains(photo) && !bandURI.isEmpty && bandURI.contains("http") {
                    self.menuImages.append(photo)
                }
            }
        }
    }
    
    func uploadTOS3Image(image:UIImage,messageObject:XMPPMessageArchiving_Message_CoreDataObject) {
        
        let name = "daliniios\(Date().timeIntervalSince1970*1000)"
        let BUCKET_DIRECTORY = "ios/\(name).jpeg"
        let path = NSTemporaryDirectory().stringByAppendingPathComponent(path: name)
        
        let data = UIImageJPEGRepresentation(image, 0.6)
        
        do {
            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
        }
        let BUCKET_NAME = "tridder"
        let S3_BASE_URL = "https://s3-us-west-2.amazonaws.com/"
        let url = NSURL(fileURLWithPath: path)
        
        let uploadRequest            = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket        = BUCKET_NAME
        uploadRequest?.acl           = AWSS3ObjectCannedACL.publicRead
        uploadRequest?.key           = BUCKET_DIRECTORY
        uploadRequest?.body          = url as URL!
        
        let transferManager = AWSS3TransferManager.default()
        transferManager?.upload(uploadRequest).continue(with: AWSExecutor.mainThread(), with:{(task) -> AnyObject in
            
            if FileManager.default.fileExists(atPath: path){
                try? FileManager.default.removeItem(atPath: path)
            }
            
            if(task.error != nil){
                // print_debug(object:"%@", task.error as Any);
            }else{
                let url = "\(S3_BASE_URL)\(BUCKET_NAME)/\(BUCKET_DIRECTORY)"
                print_debug(object: url)
                
                if let stream = XMPPhelper.sharedInstance().xmppStream{
                    
                    let messageBody = DDXMLElement(name: "body", stringValue: "Image")
                    let message = XMPPMessage(type: "chat", to: XMPPJID(string:self.other_user_id+"@"+xmppHostNameJidSubString), elementID: "\(stream.generateUUID()!)", child: messageBody)
                    
                    message?.addOut(ofBandURI: url, desc: "1", businessId: "")
                    //message?.addMarkableChatMarker()
                    stream.send(message!)
                }
                
                let placeHolderImagePath = documentsDirectoryPath+"\(messageObject.message.outOfBandURI() ?? "")"
                if FileManager.default.fileExists(atPath: placeHolderImagePath){
                    try? FileManager.default.removeItem(atPath: placeHolderImagePath)
                }
                
                deleteModel(managedObject:messageObject)
            }
            return "" as AnyObject
        })
    }
	
    func showAlert(message:String,title:String = ""){
        
        let alertVc = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelBtnAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertVc.addAction(cancelBtnAction)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    
    func adjustTextViewHeight(){
        
        var frame = self.textView.frame;
        let fixedWidth = frame.size.width
        
        var newSize = self.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(100)))
        newSize.width = CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth)))
        newSize.height = CGFloat(fminf(Float(newSize.height), Float(120)))
        frame.size = newSize
        
        self.textViewContainerHeight.constant = frame.size.height+16
        self.textView.layer.masksToBounds = true
        
        DispatchQueue.main.async {
            
            self.moveToLatestChatMessage(animate:false)
        }
    }
    
    
    //MARK:- ==========================
    //MARK: Calculate the size of text
    func textSizeCount(text: String?, font: UIFont, bundingSize size: CGSize) -> CGSize {
        
        if text == nil{
            return CGSize(width: 0, height: 0)
        }
        let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes: [String : AnyObject] = [NSFontAttributeName: font, NSParagraphStyleAttributeName: mutableParagraphStyle]
        let tempStr = NSString(string: text!)
        
        let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceilf(Float(rect.size.height))
        let width = ceilf(Float(rect.size.width))
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    func showAlert(message:String){
        
        let controller = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelBtnAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        controller.addAction(cancelBtnAction)
        self.present(controller, animated: true, completion: nil)
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
    
    
    func sendRemotePush(_ notification:Foundation.Notification){
        
    }
    
    //MARK:- IBActions
    //MARK:- ==========================================
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imageBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
        self.takeImageFromCameraGallery(fromViewController: self)
    }
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        if self.isAdmin{
            
            var params = JSONDictionary()
            
            self.textView.text = self.textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if CurrentUser.user_id != nil{
                
                params["userId"] = CurrentUser.user_id as AnyObject
                
            }
            
            params["message"] = self.textView.text as AnyObject
            
            saveFeedbackAPI(params: params, webServiceSuccess: { (success, msg, data) in
                self.getFeedbackMessages()
                
            })
            
        }else{
            guard let _ = XMPPhelper.sharedInstance().xmppStream else {
                return
            }
            if self.textView.text == nil || self.textView.text.characters.count == 0 && XMPPhelper.sharedInstance()?.xmppStream != nil{
                return;
            }
            
            let messageBody = DDXMLElement(name: "body", stringValue: self.textView.text)
            let message = XMPPMessage(type: "chat", to: XMPPJID(string:self.other_user_id+"@"+xmppHostNameJidSubString), elementID: "\(XMPPhelper.sharedInstance().xmppStream!.generateUUID()!)", child: messageBody)
            
            XMPPhelper.sharedInstance().xmppStream.send(message!)
            
            let description = message?.outOfBandDesc() ?? ""
            var messages = message?.body() ?? ""//obj.body ?? ""
            
            if description == "1" {
                
                messages = "image"
                
            } else if description == "2" {
                messages = "location"
            }
            
            var params = JSONDictionary()
            params["userId"] = self.user_id
            params["recieverId"] = self.other_user_id
            params["message"] = messages
            
            chatNotificationAPI(params: params) { (success, msg, data) in
                //hideLoader()
                
                if success{
                    
                    
                }
            }
        }
        self.textView.text = ""
        self.adjustTextViewHeight()
        
    }

}


//MARK:- UITabeleview delegate datasource
//MARK:- ==========================================


extension ChatViewControllerSwift:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isAdmin{
            
            return self.feedbackMessageList.count
            
        }else{
            
            return self.chatObjectsArray.count
            
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.isAdmin{
            
            
            return UITableViewAutomaticDimension
            
            
        }else{
            let info = self.chatObjectsArray[indexPath.row]
            if let outOfBandDesc = info.message?.outOfBandDesc(),outOfBandDesc != "0"{
                return UITableViewAutomaticDimension
            }
            let textSize = self.textSizeCount(text: info.body, font: UIFont.systemFont(ofSize:13), bundingSize: CGSize(width: (info.outgoing == NSNumber(value:0)) ? tableView.bounds.size.width-130:tableView.bounds.size.width-80, height: CGFloat(10000.0)))
            return textSize.height+60.0
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.isAdmin{
            
            var incomming = false
            
            if let reply = self.feedbackMessageList[indexPath.row].reply{
                
                if "\(reply)" == "0"{
                    incomming = false
                    
                }else{
                    incomming = true
                    
                }
            }
            
            let identifier = incomming ? "cell":"cellSender"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatTableCell
            
            cell.userImgView.image = UIImage(named:"ic_following_placeholder")
            
            if let date = self.feedbackMessageList[indexPath.row].created_date{
				
                cell.timeLbl.text = setDateFormateWith_24Hrs(dateString: date)
                
            }
            
            cell.message.preferredMaxLayoutWidth = cell.message.bounds.width
            
            if let message = self.feedbackMessageList[indexPath.row].message{
                
                cell.message.text = message
                
            }
            
            
            
            var textSize = self.textSizeCount(text: cell.message.text, font: cell.message.font!, bundingSize: CGSize(width: incomming ? tableView.bounds.size.width-120:tableView.bounds.size.width-70, height: CGFloat(10000.0)))
            textSize.width = (textSize.width < 50 ? textSize.width : textSize.width)
            cell.textLblWidthConstraint.constant = textSize.width
            cell.containerView.backgroundColor = UIColor(colorLiteralRed: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
            
            
            return cell
            
            
        }else{
            
            print_debug(object: "indexPath.row")
            print_debug(object: indexPath.row)
            print_debug(object: self.chatObjectsArray[indexPath.row])
            let info = self.chatObjectsArray[indexPath.row]
            
            //print_debug(object:"info-> \(info)")
            var incomming = false
            if info.outgoing == NSNumber(value:0) {
                //incomming
                incomming = true
            }
            let description = info.message?.outOfBandDesc()
            let bandURI = info.message?.outOfBandURI() ?? ""
            //let businessId = info.message?.outOfBandBusinessId() ?? ""
            
            if description == "imageTemp" {
                
                let identifier = incomming ? "cellImage":"cellImageSender"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatTableImageCell
                cell.imgView.image = UIImage(contentsOfFile: documentsDirectoryPath+bandURI)
                cell.timeLbl.text = self.stringFromDate(date: info.timestamp, dateFormat: "d MMM yyyy, h:mm a")
                if incomming{
                    
                    cell.seenImgView.isHidden = true
                    if let url = URL(string:self.otherUserProfileImageUrl) {
                        cell.userImgView.sd_setImage(with: url, placeholderImage:UIImage(named:"ic_user_profile_small_placeholder"))
                    }
                    else{
                        cell.userImgView.image = UIImage(named:"ic_user_profile_small_placeholder")
                    }
                }
                else{
                    cell.seenImgView.isHidden = true
                    cell.setMessageStatusImage(status: info.markStatus)
                }
                cell.activityLoader?.isHidden = false
                cell.activityLoader?.startAnimating()
                return cell
            }
            else if description == "1" {
                
                let identifier = incomming ? "cellImage":"cellImageSender"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatTableImageCell
                cell.timeLbl.text = self.stringFromDate(date: info.timestamp, dateFormat: "d MMM yyyy, h:mm a")
                
                if incomming{
                    
                    cell.seenImgView.isHidden = true
                    
                    cell.imgView.sd_setImage(with: URL(string:bandURI), placeholderImage: activityPlaceholder)
                    
                    if let url = URL(string:self.otherUserProfileImageUrl) {
                        cell.userImgView.sd_setImage(with: url, placeholderImage:UIImage(named:"ic_user_profile_small_placeholder"))
                    }
                    else{
                        cell.userImgView.image = UIImage(named:"ic_user_profile_small_placeholder")
                    }
                }
                else{
                    cell.seenImgView.isHidden = true
                    
                    //let url = URL(string:bandURI)!
                    
                    cell.imgView.sd_setImage(with: URL(string:bandURI), placeholderImage: activityPlaceholder)
                    
                    cell.setMessageStatusImage(status: info.markStatus)
                }
                cell.activityLoader?.isHidden = true
                return cell
            }
            else if description == "2" {
                let identifier = incomming ? "cellLocation":"cellLocationSender"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatTableLocationCell
                cell.timeLbl.text = self.stringFromDate(date: info.timestamp, dateFormat: "d MMM yyyy, h:mm a")
                
                if incomming{
                    
                    cell.seenImgView.isHidden = true
                    if let url = URL(string:self.otherUserProfileImageUrl) {
                        cell.userImgView.sd_setImage(with: url, placeholderImage:UIImage(named:"ic_user_profile_small_placeholder"))
                    }
                    else{
                        cell.userImgView.image = UIImage(named:"ic_user_profile_small_placeholder")
                    }
                }
                else{
                    cell.seenImgView.isHidden = true
                    
                    cell.setMessageStatusImage(status: info.markStatus)
                }
                
                return cell
            }
            else{
                
                let identifier = incomming ? "cell":"cellSender"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatTableCell
                
                if incomming{
                    
                    cell.seenImgView.isHidden = true
                    if let url = URL(string:self.otherUserProfileImageUrl) {
                        cell.userImgView.sd_setImage(with: url, placeholderImage:UIImage(named:"ic_user_profile_small_placeholder"))
                    }
                    else{
                        cell.userImgView.image = UIImage(named:"ic_user_profile_small_placeholder")
                    }
                    cell.containerView.backgroundColor = UIColor(colorLiteralRed: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
                    
                }
                else{
                    cell.seenImgView.isHidden = true
                    cell.containerView.backgroundColor = AppColor.blue
                    
                    cell.setMessageStatusImage(status: info.markStatus)
                }
                
                cell.timeLbl.text = self.stringFromDate(date: info.timestamp, dateFormat: "d MMM yyyy, h:mm a")
                
                cell.message.preferredMaxLayoutWidth = cell.message.bounds.width
                
                if description == "4" {
                    
                    
                }
                else{
                    cell.message.text = info.body
                    
                    
                }
                var textSize = self.textSizeCount(text: cell.message.text, font: cell.message.font!, bundingSize: CGSize(width: incomming ? tableView.bounds.size.width-120:tableView.bounds.size.width-70, height: CGFloat(10000.0)))
                textSize.width = (textSize.width < 50 ? textSize.width : textSize.width)
                cell.textLblWidthConstraint.constant = textSize.width
                
                
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !self.isAdmin{
            if tableView != chatTableView {
                return
            }
            
            let info = self.chatObjectsArray[indexPath.row]
            
            let description = info.message?.outOfBandDesc()
            _ = info.message?.outOfBandURI() ?? ""
            if description == "4" {
                
            } else if description == "2" {
            } else if description == "1" {
                
                guard let cell = tableView.cellForRow(at: indexPath) as? ChatTableImageCell else {
                    return
                }
                guard let originImage = cell.imgView.image else {
                    return
                }
                
                
                let browser = SKPhotoBrowser(originImage: originImage , photos: menuImages, animatedFromView: cell)
                let item = self.chatObjectsArray[indexPath.row]
                let bandURI = item.message?.outOfBandURI() ?? ""
                let description = item.message?.outOfBandDesc()
                if description == "1" {
                    
                    var counter = 0
                    for  item in self.menuImages {
                        if item.photoURL == bandURI {
                            print_debug(object: "test")
                            browser.initializePageIndex(counter)
                        }
                        counter += 1
                    }
                    
                    browser.delegate = self
                    
                    present(browser, animated: true, completion: {})
                }
            }
        }
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if indexPath.row == self.feedbackMessageList.count - 1 {
    //            self.getFeedbackMessages()
    //        }
    //    }
    //    func initializeRefreshControl() {
    //        let indicatorFooter = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.chatTableView.frame.width, height: 44))
    //        indicatorFooter.color = UIColor.black
    //        indicatorFooter.startAnimating()
    //        self.chatTableView.tableFooterView = indicatorFooter
    //    }
    //
    //    func refreshTableVeiwList() {
    //        self.getFeedbackMessages()
    //    }
    //
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height {
    //            self.refreshTableVeiwList()
    //        }
    //    }
    
}


//MARK:- SKPhotobrowse delegate
//MARK:- ==========================================


extension ChatViewControllerSwift : SKPhotoBrowserDelegate {
    // MARK: - SKPhotoBrowserDelegate
    func didShowPhotoAtIndex(_ index: Int) {
        // do some handle if you need
    }
    
    func willDismissAtPageIndex(_ index: Int) {
        // do some handle if you need
    }
    
    func willShowActionSheet(_ photoIndex: Int) {
        // do some handle if you need
    }
    
    func didDismissAtPageIndex(_ index: Int) {
        // do some handle if you need
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
        // handle dismissing custom actions
    }
}



//MARK:- UITextfield delegate methods
//MARK:- ==========================================


extension ChatViewControllerSwift:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.moveToLatestChatMessage(animate:true)
        })
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //        if text.containsEmoji {
        //            return false
        //        }
        
        if text == "\n" && (textView.text == nil || textView.text!.characters.count == 0) {
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight()
    }
    
    
    func moveToLatestChatMessage(animate:Bool = true){
        
        if self.isAdmin{
            
            if !self.feedbackMessageList.isEmpty {
                
                let topIndexPath = IndexPath(row: self.feedbackMessageList.count-1, section: 0)
                
                if let cell = self.chatTableView.cellForRow(at: topIndexPath){
                    if !self.chatTableView.visibleCells.contains(cell){
                        self.chatTableView.scrollToRow(at: topIndexPath, at: UITableViewScrollPosition.top, animated: animate)
                    }
                }
                else{
                    
                    DispatchQueue.main.async {
                        self.chatTableView.scrollToRow(at: topIndexPath, at: UITableViewScrollPosition.top, animated: animate)
                    }
                }
            }
            
        }else{
            
            if self.chatObjectsArray.count > 1 {
                let topIndexPath = IndexPath(row: self.chatObjectsArray.count-1, section: 0)
                
                if let cell = self.chatTableView.cellForRow(at: topIndexPath){
                    if !self.chatTableView.visibleCells.contains(cell){
                        self.chatTableView.scrollToRow(at: topIndexPath, at: UITableViewScrollPosition.middle, animated: animate)
                    }
                }
                else{
                    self.chatTableView.scrollToRow(at: topIndexPath, at: UITableViewScrollPosition.middle, animated: animate)
                }
            }
        }
    }
}


//MARK:- Fetch chat result delegate
//MARK:- ==========================================


extension ChatViewControllerSwift:NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //self.chatTableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.filterChat()
        self.moveToLatestChatMessage(animate:true)
    }
}


//MARK:- UIImage picker view delegate
//MARK:- ==========================================

extension ChatViewControllerSwift:UIImagePickerControllerDelegate,UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: false) { () -> Void in
            
            if var image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                image = image.fixOrientation()
                if !(self.reachabilityManager?.isReachable)! && XMPPhelper.sharedInstance()?.xmppStream != nil{
                    return
                }
                let messageBody = DDXMLElement(name: "body", stringValue: "1")
                let message = XMPPMessage(type: "chat", to: XMPPJID(string:self.other_user_id+"@"+xmppHostNameJidSubString), elementID: "\(XMPPhelper.sharedInstance().xmppStream!.generateUUID()!)", child: messageBody)
                
                //In case of image
                let tempImagePath = "image\(Date().timeIntervalSince1970)"
                let _ = saveImageToDocumentDirectory(image, path: tempImagePath)
                message?.addOut(ofBandURI: "/"+tempImagePath+".png", desc: "imageTemp", businessId: "")
                
                let bareJID = XMPPJID(string:self.other_user_id+"@"+xmppHostNameJidSubString) as AnyObject
                let streamBareJidStr = (self.user_id+"@"+xmppHostNameJidSubString) as AnyObject
                let bareJidStr = (self.other_user_id+"@"+xmppHostNameJidSubString) as AnyObject
                let messageStr = "\(message!)" as AnyObject
                let timeStamp = (Date() as AnyObject)
                let isRead = NSNumber(value:0) as AnyObject
                let isOutgoing = true as AnyObject
                let outgoing = NSNumber(value:1) as AnyObject
                
                
                
                let params:[String:AnyObject] = ["message":message!,"timestamp":timeStamp,"sortedTimeStamp":timeStamp,"outgoing":outgoing,"isOutgoing":isOutgoing,"messageStr":messageStr,"bareJidStr":bareJidStr,"streamBareJidStr":streamBareJidStr,"isRead":isRead,"bareJid":bareJID,"markerStatus":"0" as AnyObject,"body":"image" as AnyObject ]
                
                let obj = insertChatData(param: params)
                
                self.uploadTOS3Image(image: image, messageObject: obj)
            }
        }
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        if !(self.reachabilityManager?.isReachable)! && XMPPhelper.sharedInstance()?.xmppStream != nil{
            return
        }
        let messageBody = DDXMLElement(name: "body", stringValue: "1")
        let message = XMPPMessage(type: "chat", to: XMPPJID(string:self.other_user_id+"@"+xmppHostNameJidSubString), elementID: "\(XMPPhelper.sharedInstance().xmppStream!.generateUUID()!)", child: messageBody)
        
        //In case of image
        let tempImagePath = "image\(Date().timeIntervalSince1970)"
        let _ = saveImageToDocumentDirectory(image, path: tempImagePath)
        message?.addOut(ofBandURI: "/"+tempImagePath+".png", desc: "imageTemp", businessId: "")
        
        let bareJID = XMPPJID(string:self.other_user_id+"@"+xmppHostNameJidSubString) as AnyObject
        let streamBareJidStr = (self.user_id+"@"+xmppHostNameJidSubString) as AnyObject
        let bareJidStr = (self.other_user_id+"@"+xmppHostNameJidSubString) as AnyObject
        let messageStr = "\(message!)" as AnyObject
        let timeStamp = (Date() as AnyObject)
        let isRead = NSNumber(value:0) as AnyObject
        let isOutgoing = true as AnyObject
        let outgoing = NSNumber(value:1) as AnyObject
        
        
        
        let params:[String:AnyObject] = ["message":message!,"timestamp":timeStamp,"sortedTimeStamp":timeStamp,"outgoing":outgoing,"isOutgoing":isOutgoing,"messageStr":messageStr,"bareJidStr":bareJidStr,"streamBareJidStr":streamBareJidStr,"isRead":isRead,"bareJid":bareJID,"markerStatus":"0" as AnyObject,"body":"image" as AnyObject ]
        
        let obj = insertChatData(param: params)
        
        self.uploadTOS3Image(image: image, messageObject: obj)
        
        cropViewController.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func takeImageFromCameraGallery(fromViewController viewController:UIViewController!) {
        
        let alertController = UIAlertController(title: "", message: "Choose from options", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let alertActionGallery = UIAlertAction(title: "Choose from gallery", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            self.checkAndOpenLibrary(fromViewController: viewController)
        }
        let alertActionCamera = UIAlertAction(title: "Take photo", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            self.checkAndOpenCamera(fromViewController: viewController)
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) in
        }
        alertController.addAction(alertActionGallery)
        alertController.addAction(alertActionCamera)
        alertController.addAction(alertActionCancel)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func checkAndOpenCamera(fromViewController viewController:UIViewController!) {
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == AVAuthorizationStatus.authorized {
            let image_picker = UIImagePickerController()
            image_picker.delegate = (viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                image_picker.sourceType = sourceType
                if image_picker.sourceType == UIImagePickerControllerSourceType.camera {
                    image_picker.allowsEditing = true
                    image_picker.showsCameraControls = true
                }
                viewController.present(image_picker, animated: true, completion: nil)
            }
            else {
                //showToastWithMessage("Camera not available")
            }
        }
        else {
            if authStatus == AVAuthorizationStatus.notDetermined {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(granted: Bool) in                DispatchQueue.main.async(execute: {                    if granted {
                    let image_picker = UIImagePickerController()
                    image_picker.delegate = (viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
                    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                        image_picker.sourceType = sourceType
                        if image_picker.sourceType == UIImagePickerControllerSourceType.camera {
                            image_picker.allowsEditing = true
                            image_picker.showsCameraControls = true
                        }
                        viewController.present(image_picker, animated: true, completion: nil)
                    }
                    else {
                        //showToastWithMessage("Camera not available")
                    }
                    }
                })
                    
                })
            }
            else {
                if authStatus == AVAuthorizationStatus.restricted {
                    
                    let alertController = UIAlertController(title: "", message: "You've been restricted from using the camera on this device. Without camera access this feature won't work.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(alertActionSettings)
                    alertController.addAction(alertActionCancel)
                    viewController.present(alertController, animated: true, completion: nil)
                }
                else {
                    
                    let alertController = UIAlertController(title: "", message: "Please change your privacy setting from the Settings app and allow access to camera for this app", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(alertActionSettings)
                    alertController.addAction(alertActionCancel)
                    viewController.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func checkAndOpenLibrary(fromViewController viewController:UIViewController!) {
        
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if (status == .notDetermined) {
            let image_picker = UIImagePickerController()
            image_picker.delegate = (viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
            image_picker.sourceType = sourceType
            image_picker.allowsEditing=true
            viewController.present(image_picker, animated: true, completion: nil)
            let assetsLibrary: ALAssetsLibrary = ALAssetsLibrary()
            assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAll,
                                                   usingBlock: {
                                                    group,stop in
                                                    if (stop?.pointee.boolValue)!{
                                                        return
                                                    }
                                                    stop?.pointee = true
                                                    
            }, failureBlock: {
                error in
                image_picker.dismiss(animated: true, completion: nil)
                
            })
        }
        else {
            if status == .restricted {
                
                let alertController = UIAlertController(title: "", message: "You've been restricted from using the library on this device. Without camera access this feature won't work.", preferredStyle: UIAlertControllerStyle.alert)
                
                let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                }
                let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                }
                alertController.addAction(alertActionSettings)
                alertController.addAction(alertActionCancel)
                viewController.present(alertController, animated: true, completion: nil)
                
            }
            else {
                if status == .denied {
                    
                    let alertController = UIAlertController(title: "", message: "Please change your privacy setting from the Settings app and allow access to library for this app", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(alertActionSettings)
                    alertController.addAction(alertActionCancel)
                    viewController.present(alertController, animated: true, completion: nil)
                }
                else {
                    if status == .authorized {
                        let image_picker = UIImagePickerController()
                        image_picker.delegate = (viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
                        image_picker.sourceType = sourceType
                        image_picker.allowsEditing=true
                        viewController.present(image_picker, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}



extension ChatViewControllerSwift{
    
    func handleTapGesture(_ gesture : UILongPressGestureRecognizer){
        
        guard gesture.state == .began else{return}
        
        let tap = gesture.location(in: self.chatTableView)
        
        guard let index = self.chatTableView.indexPathForRow(at: tap)else{
            return
        }
        
        guard let cell = self.chatTableView.cellForRow(at: index) else{
            return
        }
        
        self.selectedIdx = index
        let rectangleFrame = CGRect(x: (cell.contentView.bounds.size.width-100)/2, y: 30, width: 100, height: 100)
        let menu  = UIMenuController.shared
        menu.setTargetRect(rectangleFrame, in: cell.contentView)
        menu.isMenuVisible = true
        let menuItem = UIMenuItem(title: "copy", action: #selector(copyText))
        menu.menuItems = [menuItem]
        menu.setMenuVisible(true, animated: true)
        
    }
    
    
    
    func copyText(){
        
        guard let index = self.selectedIdx else{
            return
        }
        
        let info = self.chatObjectsArray[index.row]
        
        UIPasteboard.general.string = info.body
        
    }
    
}

