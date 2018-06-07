//
//  ReplyVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 10/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

protocol SetReplyListDelegate {
    
    func setReplyList()
    
}

class ReplyVC: UIViewController {

    
    //MARK:- IBOutlets
    //MARK:- ==================================


    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var replyTableview: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var replyTextView: KMPlaceholderTextView!
    @IBOutlet weak var chatTableContainerView: UIView!
    @IBOutlet weak var textContainerBottomConstraint: NSLayoutConstraint!

    
    //MARK:- Propertes
    //MARK:- ==================================

    var replyList = [ReplyModel]()
    var index = 0
    var userDetail = ForecastPostDetailModel()
    var commentDetail = CommentModel()
    var delegate: SetReplyListDelegate!
    var keyboardShow: NSObjectProtocol?, keyboardHide: NSObjectProtocol?



    //MARK:- View life cycle
    //MARK:- ==================================

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initialSetup()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        var tapGasture =  UITapGestureRecognizer()
        tapGasture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification:Notification!) -> Void in
            
            self.view.addGestureRecognizer(tapGasture)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil,
                                               
                                               queue: OperationQueue.main) {_ in
                                                
                                                self.view.removeGestureRecognizer(tapGasture)
                                                
        }
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        self.addKeyBoardSetup()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true

        self.removeKeyBoardSetup()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Private methods
    //MARK:- ==================================

    func initialSetup(){
    
        print_debug(object: userDetail)
        
        self.replyTableview.dataSource = self
        self.replyTableview.delegate = self
        self.replyTableview.estimatedRowHeight = 100
        self.navigationTitle.font = setNavigationTitleFont()

        self.backBtn.rotateBackImage()
        self.navigationTitle.text = Reply.localized
        self.replyTextView.placeholder = write_a_reply.localized
        
        if !self.commentDetail.reply.isEmpty{
            
            self.replyList = self.commentDetail.reply
            
            self.replyTableview.reloadData()
            
            if !self.replyList.isEmpty{
                
                let indexPath = IndexPath(row: self.replyList.count - 1 , section: 0)
                
                self.replyTableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
                
            }
            
        }
        
    }
    
    
    func dismissKeyboard(_sender: AnyObject){
        
        self.view.endEditing(true)
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
    
    func getCommentList(){
        
        var params = JSONDictionary()
        
            params["postId"] = self.userDetail.forecast_id ?? ""
        
        commentListAPI(params: params) { (success, msg, data) in
            if success{
                
                var commentList : [CommentModel] = []
                
                commentList = data!.map({ (comment) -> CommentModel in
                    CommentModel(with: comment)
                })

                
                if let postId = self.commentDetail.comment_id{
                
                    let filter = commentList.filter({$0.comment_id == postId})
                  
                    if !(filter.isEmpty){
                        
                        self.replyList = filter.first!.reply
                      
                    }
                }
                self.replyTableview.reloadData()
                if !self.replyList.isEmpty{
                    
                    let indexPath = IndexPath(row: self.replyList.count - 1 , section: 0)
                    
                    self.replyTableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    
                }

                showToastWithMessage(msg: msg)
            }
        }
    }

    
    //MARK:- IBActions
    //MARK:- ==================================

    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.delegate.setReplyList()
        sharedAppdelegate.nvc.popViewController(animated: true)
        
    }

    
    
    @IBAction func senBtnTapped(_ sender: UIButton) {
        
        var params = JSONDictionary()
        
            params["userId"] = CurrentUser.user_id ?? ""
        
            params["forecastId"] = self.userDetail.forecast_id
        
            params["commentId"] = self.commentDetail.comment_id
        
        if self.replyTextView.text != nil && !self.replyTextView.text.isEmpty{
            
            params["comment"] = self.replyTextView.text! as AnyObject?
            
        }else{
            
            showToastWithMessage(msg: Please_add_a_comment.localized)
        }
        
        showLoader()
        
        saveRepplyCommentAPI(params: params) { (success, msg, data) in
            hideLoader()
            
            if success{
                self.replyTextView.text = ""
                self.replyTextView.endEditing(true)
                self.replyTextView.resignFirstResponder()
//                self.getCommentList()
                self.delegate.setReplyList()
                sharedAppdelegate.nvc.popViewController(animated: true)

                
            }
        }
        
    }
    
}


//MARK:- TableView Delegate and datasource
//MARK:- =============================================

extension ReplyVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.replyList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentReplyCell", for: indexPath) as? PostCommentReplyCell else{
            fatalError("Cell not found")
        }
        cell.setUpView()
        
        cell.userInfoBtn.addTarget(self, action: #selector(userInfoBtntapped(_:)), for: .touchUpInside)

        cell.populateData(info: replyList[indexPath.row],index: indexPath.row)
        
        cell.replySeperatoe.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.view.endEditing(true)
//    }

    
    //MARK:- Target methods
    //MARK:- ========================================

    
    func userInfoBtntapped(_ sender: UIButton){
        
        guard let indexpath = sender.tableViewIndexPath(tableView: self.replyTableview) else{
            
            return
        }
        
        let data = self.replyList[indexpath.row]
        
        self.gotoProfile(user_id: data.user_id)
        
    }
    
    
    
    func gotoProfile(user_id: Int){
        
        if CurrentUser.user_id != nil{
            
            if user_id == currentUserId(){
                
                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
                
                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                
            }else{
                
                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                
                obj.userID = user_id
                
                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            }
        }
        
    }

}



