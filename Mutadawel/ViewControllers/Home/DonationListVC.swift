//
//  CommentVC.swift
//  Mutadawel
//
//  Created by Appinventiv on 20/02/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import SwiftyJSON


class DonationListVC: MutadawelBaseVC {
    
    
    //MARK:- IBOutlets
    //MARK:- =================================
    
    @IBOutlet weak var donationBgView: UIView!
    @IBOutlet weak var donationListLbl: UILabel!
    @IBOutlet weak var donationlistTableView: UITableView!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var enterAcTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var donationcloseBtn: UIButton!
    
    
    //MARK:- Properties
    //MARK:- =================================
    
    var donationList = JSONArray()
    
    
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
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Private Methods
    //MARK:- =================================
    
    
    private func initialSetup(){
        
        self.donationlistTableView.delegate = self
        self.donationlistTableView.dataSource = self
        
        if sharedAppdelegate.appLanguage == .Arabic{
            self.enterAcTextField.textAlignment = .right
        }else{
            
            self.enterAcTextField.textAlignment = .left
            
        }
        
            self.enterAcTextField.isHidden = true
            self.getDonationList()
            
        
        self.donationListLbl.text = MY_DONATION_LIST.localized
        self.donationcloseBtn.setTitle(CLOSE.localized, for: .normal)
        self.donationBgView.layer.cornerRadius = 3
        self.donationBgView.layer.masksToBounds = true
        
    }
    
    
    func dismissKeyboard(_sender: AnyObject){
        self.view.endEditing(true)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    func getDonationList(){
        
        var params = JSONDictionary()
        
        params["userId"] = CurrentUser.user_id!
        
        myDonationListAPI(params: params) { (success, msg, data) in
            
            if success{
                
                self.donationList = data!
                
                self.donationlistTableView.reloadData()
                
            }
        }
    }
    
    
    
    
    
    
    //MARK:- IBActions
    //MARK:- =================================
    
    
    
    
    @IBAction func donationCloseBtnTapped(_ sender: UIButton) {
        sharedAppdelegate.nvc.popViewController(animated: true)
    }
    
}

//MARK:- TableView Delegate and datasource
//MARK:- =============================================

extension DonationListVC: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
        
    }
    
}

//MARK:- TableView Delegate and datasource
//MARK:- =============================================

extension DonationListVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
            return self.donationList.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonationListCell", for: indexPath) as! DonationListCell
            
            let data = self.donationList[indexPath.section]
            
            cell.populateData(info: data)
            
            cell.acceptBtn.addTarget(self, action: #selector(acceptBtnTapped(_:)), for: .touchUpInside)
            
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 155
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.view.endEditing(true)
    }
    
    
    //MARK:- Target methods
    //MARK:- =================================
    
    
    
    func gotoProfile(user_id: Int){
        
            if user_id == currentUserId(){
                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "MyProfileID") as! MyProfileVC
                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
                
            }else{
                let obj = sideMenuStoryboard.instantiateViewController(withIdentifier: "OtherUserProfileVc") as! OtherUserProfileVc
                obj.userID = user_id
                sharedAppdelegate.nvc.pushViewController(obj, animated: true)
            }
        
    }
    
    
    
    
    
    
    func acceptBtnTapped(_ sender: UIButton){
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.donationlistTableView) else{return}
        var params = JSONDictionary()
        
        let donationId = self.donationList[indexPath.row]["donation_id"].stringValue
            params["donationId"] = donationId
            
        showLoader()
        
        donationConfirmationAPI(params: params) { (success, msg, data) in
            hideLoader()
            
            if success{
                
                showToastWithMessage(msg: msg)
            }
        }
        
    }
    
    
}




//MARK:- TableView cell classess
//MARK:- ==============================


class DonationListCell: UITableViewCell{
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var acceptLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var acceptImg: UIImageView!
    @IBOutlet weak var acceptView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.acceptView.layer.borderColor = UIColor.gray.cgColor
        self.acceptView.layer.cornerRadius = 3
        self.acceptView.layer.masksToBounds = true
        
        
        self.userImg.layer.cornerRadius = 20
        self.userImg.layer.masksToBounds = true
        
    }
    
    
    
    func populateData(info: JSON){
        
        self.userName.text = info["name"].stringValue
        let amount = info["amount"].stringValue
        self.amount.text = "SR \(amount)"
        self.date.text = info["created_at"].stringValue
        let img = info["profile_pic"].stringValue
        let imageUrl = URL(string: img)
        self.userImg.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "ic_profile_placeholder"))
        let status = info["status"].intValue
        
            if status == 1 {
                
                self.acceptLbl.text = TRANSFER_FROM_TRIDDER.localized
                self.acceptImg.isHidden = true
                
            }else if status == 2  || status == 3{
                
                self.acceptLbl.text = SUCCESSFULL_TRANSFER.localized
                self.acceptImg.isHidden = true
                //self.acceptImg.image = #imageLiteral(resourceName: <#T##String#>)
                self.acceptView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                
                
            }else {
                
                self.acceptLbl.text = TRANSFER_FROM_TRIDDER.localized
                self.acceptImg.isHidden = true
            }
        
        
    }
}

