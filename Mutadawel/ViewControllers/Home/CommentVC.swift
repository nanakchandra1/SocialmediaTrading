//
//  CommentVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 20/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit

enum SetView {
    case Comment,Donation
}

enum SelectTextView {
    case Comment,Repply
}


class CommentVC: MutadawelBaseVC {
    
    
    //MARK:- IBOutlets
    //MARK:- =================================

    @IBOutlet var navigationTitle: UILabel!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var writeCommentTextView: KMPlaceholderTextView!
    @IBOutlet weak var chatTableContainerView: UIView!
    @IBOutlet weak var textContainerBottomConstraint: NSLayoutConstraint!

	@IBOutlet weak var sendButton: UIButton!
	
    //MARK:- Properties
    //MARK:- =================================

    var commentArray = JSONDictionaryArray()
    var replArray = JSONDictionaryArray()
    var selectIndx: NSIndexPath?
    var setView = SetView.Comment
    var userDetail = ForecastPostDetailModel()
    var commentList = [CommentModel]()
    var donationList = JSONDictionaryArray()
    var selectTextView = SelectTextView.Comment
    var index = 0
    var delegate:TimeLineDelegate!
    var isComment = false
    var keyboardShow: NSObjectProtocol?, keyboardHide: NSObjectProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.initialSetup()
		
	}

    //MARK:- View life cycle
    //MARK:- =================================

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
    }

    
    //MARK:- Private Methods
    //MARK:- =================================

    
    private func initialSetup(){
		
		if sharedAppdelegate.appLanguage == .Arabic{
			
			
			//self.sendButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
			self.sendButton.setImage(#imageLiteral(resourceName: "ic_add_new_post_sent_grey@2x_left"), for: .normal)
			
		}else{
			
//			self.sendButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
			self.sendButton.setImage(#imageLiteral(resourceName: "ic_add_new_post_sent_grey"),for: .normal)
		}
		
        self.navigationTitle.font = setNavigationTitleFont()
        self.navigationTitle.text = COMMENT.localized
        self.writeCommentTextView.delegate = self
        self.commentTableView.estimatedRowHeight = 100
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        self.writeCommentTextView.placeholder = write_a_comment.localized
        self.backBtn.rotateBackImage()
        self.getCommentList()
		
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
    
    
    func dismissKeyboard(_sender: AnyObject){
        self.view.endEditing(true)
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    
    func showNodata(){
        
        if self.commentList.isEmpty{
            
            self.commentTableView.backgroundView = makeLbl(view: self.commentTableView, msg: No_Comments_on_this_Posts.localized)
            
            self.commentTableView.backgroundView?.isHidden = false
            
        }else{
            
            self.commentTableView.backgroundView?.isHidden = true
        }
    }
    
    
    func getCommentList(){
        
        var params = JSONDictionary()
        
            params["postId"] = self.userDetail.forecast_id
            
        commentListAPI(params: params) { (success, msg, data) in
            
            if success{
                
                    self.commentList = data!.map({ (comment) -> CommentModel in
                        CommentModel(with: comment)
                    })
                
                self.commentTableView.reloadData()
                
                
                    if !self.commentList.last!.reply.isEmpty{
                        
                        let indexPath = IndexPath(row: self.commentList.last!.reply.count , section: self.commentList.count - 1)

                        self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)

                    }else{
                        let indexPath = IndexPath(row: 0 , section: self.commentList.count - 1)

                        self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)

                    }
                    
                //showToastWithMessage(msg: msg)
                
            }
            self.showNodata()
        }
    }
    

    
    func saveComment(){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id!
        params["comment"] = self.writeCommentTextView.text!
        params["forecastId"] = self.userDetail.forecast_id
        
        showLoader()

        saveCommentAPI(params: params) { (success, msg, data) in
            hideLoader()

            if success{
                self.isComment = true
                self.writeCommentTextView.text = ""
                self.writeCommentTextView.endEditing(true)
                self.writeCommentTextView.resignFirstResponder()
                self.getCommentList()
            }
        }
    }
    
    
    func repplyComment(){
        
        let data = self.commentList[index]
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id ?? ""
        params["forecastId"] = self.userDetail.forecast_id
        params["commentId"] = data.comment_id
        
        if self.writeCommentTextView.text != nil && !self.writeCommentTextView.text.isEmpty{
            
            params["comment"] = self.writeCommentTextView.text!
            
        }else{
            
            showToastWithMessage(msg: Please_add_a_comment.localized)
        }

        
        showLoader()

        saveRepplyCommentAPI(params: params) { (success, msg, data) in
            hideLoader()

            if success{
                self.selectTextView = .Comment
                self.writeCommentTextView.text = ""
                self.writeCommentTextView.endEditing(true)
                self.writeCommentTextView.resignFirstResponder()
                self.getCommentList()
            }
        }
    }
    
    
    //MARK:- IBActions
    //MARK:- =================================

    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        self.delegate.refreshTimeline(nil,count: self.commentList.count, isComment: self.isComment)

        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func sendCommentBtnTaped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if self.selectTextView == .Comment{
            self.saveComment()
        }else{
            self.repplyComment()
        }
    }
    
}


//MARK:- TableView Delegate and datasource
//MARK:- =============================================

extension CommentVC: UITextViewDelegate{

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
        
    }
}


//MARK:- TableView Delegate and datasource
//MARK:- =============================================

extension CommentVC: UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.setView == .Comment && tableView === self.commentTableView{
            return self.commentList.count
        }else{
            return self.donationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.setView == .Comment && tableView === self.commentTableView{
            
            let data = self.commentList[section]
            
            guard !data.reply.isEmpty else{return 1}
            
            return data.reply.count + 1
            
        }else{
            
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let data = self.commentList[indexPath.section]

            if indexPath.row == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentCell", for: indexPath) as! PostCommentCell
                cell.replyBtn.addTarget(self, action: #selector(replyBtnTapped(_:)), for: .touchUpInside)
                cell.userInfoBtn.addTarget(self, action: #selector(userInfoBtntapped(_:)), for: .touchUpInside)

                cell.setUpView()
                cell.populateData(info: data)
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentReplyCell", for: indexPath) as! PostCommentReplyCell
                
                cell.setUpView()
                
                cell.userInfoBtn.addTarget(self, action: #selector(userInfoBtntapped(_:)), for: .touchUpInside)

                guard !data.reply.isEmpty else{return cell}
                
                if data.reply.count == indexPath.row{
                    
                    cell.replySeperatoe.isHidden = false
                    
                }else{
                    
                    cell.replySeperatoe.isHidden = true
                    
                }
                
                cell.populateData(info: data.reply[indexPath.row - 1],index: indexPath.row)
                return cell
            }
            
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.setView == .Comment && tableView === self.commentTableView {
        if indexPath.row == 0{
            return UITableViewAutomaticDimension

        }
        
        let data = self.commentList[indexPath.section]
            
            if !data.reply.isEmpty{
                
                return UITableViewAutomaticDimension
                
            }else{
                
                return 0
                
            }
        }
        
        return 155
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        self.view.endEditing(true)
//    }
    
    
    
    //MARK:- Target methods
    //MARK:- =================================

    
    func userInfoBtntapped(_ sender: UIButton){
        
        guard let indexpath = sender.tableViewIndexPath(tableView: self.commentTableView) else{
            return
        }

        let data = self.commentList[indexpath.section]
        
        if indexpath.row == 0{
            
            
            self.gotoProfile(user_id: data.user_id)

            
        }else{
        
            if !data.reply.isEmpty{
                
                let replyData = data.reply[indexpath.row - 1]
                
                self.gotoProfile(user_id: replyData.user_id)
            }
            
        }
        
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
    
    func replyBtnTapped(_ sender: UIButton){
        
        guard let indexpath = sender.tableViewIndexPath(tableView: self.commentTableView) else{
            return
        }
        
        guard let obj = self.storyboard?.instantiateViewController(withIdentifier: "ReplyID") as? ReplyVC else{
            return
        }
        
        let data = self.commentList[indexpath.section]
        obj.commentDetail = data
        obj.userDetail = self.userDetail
        obj.delegate = self
        sharedAppdelegate.nvc.pushViewController(obj, animated: true)
        
    }

    
    func sendTapped(_ sender: UIButton){
    
        self.selectIndx = nil
        self.commentTableView.reloadData()
    }
    
    
    
    
}

//MARK:- set reply delegate method
//MARK:- =================================


extension CommentVC: SetReplyListDelegate{

    func setReplyList() {
        self.getCommentList()
    }
}


//MARK:- Textfield delegate methods
//MARK:- ==========================================

extension CommentVC: UITextFieldDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
    
}


//MARK:- TableView cell classess
//MARK:- =============================================

class PostCommentCell: UITableViewCell{
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userInfoBtn: UIButton!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var commentSeperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.replyBtn.setTitle(Reply.localized, for: .normal)
    }
    
    func setUpView(){
        self.userImg.layer.cornerRadius = 25
        self.userImg.layer.masksToBounds = true
		self.commentLbl.numberOfLines = 3
    }
    
    
    func populateData(info: CommentModel){
    
        if let img = info.profile_pic{
            
            let imageUrl = URL(string: img)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_profile_placeholder"))
        }
        
        if let name = info.name{
            self.userName.text = name
        }
        
        if let comment = info.comment{
            self.commentLbl.text = comment
        }
        if let created_date = info.created_date {
            self.durationLbl.text = setDateFormate(dateString: created_date)
        }

        
            if info.reply.isEmpty{
                
                self.commentSeperator.isHidden = false

            }else{
                
                self.commentSeperator.isHidden = true

            }
            
        }
}


class PostCommentReplyCell: UITableViewCell{
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userInfoBtn: UIButton!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var replySeperatoe: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpView(){
        self.userImg.layer.cornerRadius = 25
        self.userImg.layer.masksToBounds = true
    }
    
    
    func populateData(info: ReplyModel,index: Int){
        
       print_debug(object: info)
        
        if let img = info.profile_pic{
            let imageUrl = URL(string: img)
            self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_profile_placeholder"))
        }
        if let name = info.name{
            self.userName.text = name
        }
        if let comment = info.comment{
            self.commentLbl.text = comment
        }
        if let created_date = info.created_date{
            self.durationLbl.text = setDateFormate(dateString: created_date)
        }

    }
}





